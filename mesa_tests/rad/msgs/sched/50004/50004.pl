#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 50004

if (scalar(@ARGV) == 0) {
  copy("50004.140.o01.var", "50004.140.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("50004.140.o01.txt", "../templates/o01.tpl",
	"../../adt/50004/york.txt", "50004.140.o01.xxx");
mesa_msgs::create_hl7("50004.140.o01");

