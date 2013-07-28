#!/usr/local/bin/perl

@array = `grep -rn "PrintLog(" . | sed -nE 's/.*PrintLog\\(@"([^"]*)", .*/\\1/p' | sort | uniq`;

$debug_plist = $ARGV[0];

# read original file
if (-e $debug_plist) {
	open (DATA_IN, "<$debug_plist");
	@in_lines = <DATA_IN>;
	close (DATA_IN); 
}

# open plist for writing 
open (DATA_OUT, ">$debug_plist");

# print default plist info up to key-value pairs section
print DATA_OUT "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print DATA_OUT "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n";
print DATA_OUT "<plist version=\"1.0\">\n";
print DATA_OUT "<dict>\n";

# print existing keys without updating them
# do not print keys that have been removed
$do_next_line = 0;
foreach $line (@in_lines) {
    print "THELINE: $line\n";
	if ($do_next_line == 1) {
		print DATA_OUT "$line";
		$do_next_line = 0;
		break;
	}

    print "111";
	if ($line =~ /<key>.*<\/key>/) {
        print "222";
		foreach $val (@array) {
            chomp $val;
            print "333-<key>$val<\/key>-";
			if ($line =~ /.*<key>$val<\/key>.*/) {
                print "444";
				print DATA_OUT "$line";
				$do_next_line = 1;
				break;
			}
		}
	}
}

# add new keys to bottom of list with value of true
foreach $val (@array) {
    chomp $val;
	$exists = 0;
	foreach $line (@in_lines) {
		if ($line =~ /<key>$val<\/key>/) {
			$exists = 1;
			break;
		}

	}

	if ($exists == 0) {
		print DATA_OUT "    <key>$val</key>\n";
		print DATA_OUT "    <true/>\n";
	}
}

# print default plist info after key-value pairs section
print DATA_OUT "</dict>\n";
print DATA_OUT "</plist>\n";

# close plist
close (DATA_OUT); 

