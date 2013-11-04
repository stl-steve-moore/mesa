#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 131

if (scalar(@ARGV) == 0) {
  copy("131.106.o01.var", "131.106.o01.xxx");
  copy("131.106us.o01.var", "131.106us.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("131.106.o01.txt", "../templates/o01.tpl",
	"../../adt/131/black.txt", "131.106.o01.xxx");
mesa_msgs::create_hl7("131.106.o01");

mesa_msgs::create_text_file_2_var_files("131.106us.o01.txt", "../templates/o01.tpl",
	"../../adt/131/black.txt", "131.106us.o01.xxx");
mesa_msgs::create_hl7("131.106us.o01");
