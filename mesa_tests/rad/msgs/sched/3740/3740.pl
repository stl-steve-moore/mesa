#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3740

if (scalar(@ARGV) == 0) {
  copy("3740.130.o01.var", "3740.130.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("3740.130.o01.txt", "../templates/o01.tpl",
	"../../adt/3740/coral.txt", "3740.130.o01.xxx");
mesa_msgs::create_hl7("3740.130.o01");


