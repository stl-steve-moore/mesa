#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
use mesa_msgs;

# Generate HL7 messages for Case 131
my @base = ('1701.102.a04', '1701.103.a04');

if (scalar(@ARGV) == 0) {
    copy("black.var", "black.txt");
} else {
# The file black.txt would have been produced externally
}

foreach $b (@base) {
    mesa_msgs::create_text_file("black.txt", "../templates/a04.tpl", "1701.tmp");
    mesa_msgs::create_text_file("$b.var", "1701.tmp", "$b.txt");
    mesa_msgs::create_hl7($b);
}

