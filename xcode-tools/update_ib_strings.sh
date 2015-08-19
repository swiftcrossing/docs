#!/bin/sh
#
# update_storyboard_strings.sh - automatically extract translatable strings from storyboards and update strings files
# Based on http://forums.macrumors.com/showpost.php?p=16060008&postcount=4 by mikezang

storyboardExt=".storyboard"
stringsExt=".strings"
newStringsExt=".strings.new"
oldStringsExt=".strings.old"
localeDirExt=".lproj"
baseString="Base"

oldIFS=$IFS
IFS=$'\n'

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "-----------------------------------------------------------------------------------"
			echo "update_ib_strings - automatically extract translatable strings from storyboards and"
			echo "                    update strings files. This runs recursively from the current"
			echo "                    directory, extracting strings from all directorys contain files"
			echo "                    with the specified file extension (storyboard|xib)."
			echo " "
			echo "                    It is assumped that directory structure is as follows:"
			echo "                    Base.lproj"
			echo "                    [locale1].lproj"
			echo "                    [locale2].lproj"
			echo " "
			echo "update_ib_strings [options]"
			echo " "
			echo "options:"
			echo "-h, --help           show brief help"
			echo "-s, --storyboard     extract storyboard strings (default)"
			echo "-x, --xib            extract xib strings"
			echo "-----------------------------------------------------------------------------------"
			exit 0
			;;
		-s|--storyboard)
			storyboardExt=".storyboard"
			echo "Extracting storyboard strings..."
			shift
			;;
		-x|--xib)
			storyboardExt=".xib"
			echo "Extracting xib strings..."
			shift
			;;
		*)
			echo "Unknown option '$1'"
			echo "usage: update_ib_strings [-h |--help] [-s | -storyboard] [-x | -xib]"
			exit 0
			;;

	esac
done

# Find storyboard file full path inside project folder
for storyboardPath in `find . -name "*$storyboardExt" -print`
do
    # Get Base strings file full path
    baseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$stringsExt/")

	# Create base strings file 
	touch -r $storyboardPath $baseStringsPath
	# Make base strings file older than the storyboard file
	touch -A -01 $baseStringsPath

	echo "---Creating Base Strings file for: $storyboardPath"
    # Extract strings form storyboard to new file
	newBaseStringsPath=$(echo "$storyboardPath" | sed "s/$storyboardExt/$newStringsExt/")
	ibtool --export-strings-file $newBaseStringsPath $storyboardPath

	# Only run iconv if $newBaseStringsPath exists to avoid overwriting existing
	if [ -f $newBaseStringsPath ]; then
		iconv -f UTF-16 -t UTF-8 $newBaseStringsPath > $baseStringsPath
		rm $newBaseStringsPath
	fi

	# ibtool sometimes fails for unknown reasons with "Interface Builder could not open
	# the document XXX because it does not exist."
	# (maybe because Xcode is writing to the file at the same time?)
	# In that case, abort the script.
	if [[ $? -ne 0 ]] ; then
		echo "Exiting due to ibtool error. Please run `killall -9 ibtoold` and try again."
		exit 1
	fi

	# Get all locale strings folder
	for localeStringsDir in `find . -name "*$localeDirExt" -print`
	do
		# Get storyboard file name and folder
		storyboardDir=$(dirname "$storyboardPath")
		localeFile=$(basename "$baseStringsPath")

		# Skip Base strings folder
		if [ $localeStringsDir != $storyboardDir ]; then

			# Get localizedStrings file name from folder 
			localeStringsPath=$localeStringsDir/$localeFile

			# Create strings file only when storyboard file newer
			if find $storyboardPath -prune -newer $localeStringsPath -print | grep -q .; then
				echo "'      $storyboardPath' is newer than '$localeStringsPath'"
				# Just copy base strings file on first time
				if [ ! -e $localeStringsPath ]; then
					cp $baseStringsPath $localeStringsPath
				else
					oldLocaleStringsPath=$(echo "$localeStringsPath" | sed "s/$stringsExt/$oldStringsExt/")
					cp $localeStringsPath $oldLocaleStringsPath
					#touch -r $localeStringsPath $oldLocaleStringsPath

					# Merge baseStringsPath to localeStringsPath
					awk 'NR == FNR && /^\/\*/ {x=$0; getline; a[x]=$0; next} /^\/\*/ {x=$0; print; getline; $0=a[x]?a[x]:$0; printf $0"\n\n"}' $oldLocaleStringsPath $baseStringsPath > $localeStringsPath

					rm $oldLocaleStringsPath
				fi
			else
				echo "      '$localeStringsDir' is already up to date."
			fi
		fi
	done

	# Remove Base strings file
	echo "   Removing Base Strings file for: $storyboardPath"
	rm $baseStringsPath
done

IFS=$oldIFS
