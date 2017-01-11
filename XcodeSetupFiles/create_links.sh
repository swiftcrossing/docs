#!/usr/bin/env bash
# Create the proper links from ~/ to my dot files.

# exit after printing first argument to this function
function die {
    # echo the first argument
    echo $1

    exit 1
}

function super_link {
    file_name=$1
    link_target=$2

    if [ ! -e $link_target -o -L $link_target ]
	then
		ln -sF $file_name $link_target
	else
		echo "ERROR! $link_target is not a link."
	fi
}

function make_directory {
    directory=$1

    if [ ! -e $directory ]
    then
        mkdir $directory
    else
		echo "WARNING! $directory is alreay a directory"
    fi  
}

# Xcode key binding files
super_link $HOME/docs/XcodeSetupFiles/KeyBindings/NolansKeyBindings.idekeybindings $HOME/Library/Developer/Xcode/UserData/KeyBindings/NolansKeyBindings.idekeybindings

# Xcode code snippet files
make_directory $HOME/Library/Developer/Xcode/UserData/CodeSnippets/
docspath=$HOME/docs/XcodeSetupFiles/CodeSnippets/
linkpath=$HOME/Library/Developer/Xcode/UserData/CodeSnippets/
for filename in $docspath*.codesnippet; do
	super_link $filename $linkpath${filename#$docspath}
done

# Xcode Fonts and Colors files
make_directory $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/
docspath=$HOME/docs/XcodeSetupFiles/FontAndColorThemes/
linkpath=$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/
for filename in $docspath*.xccolortheme; do
	super_link $filename $linkpath${filename#$docspath}
done

