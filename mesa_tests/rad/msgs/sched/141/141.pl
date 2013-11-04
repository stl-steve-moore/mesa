#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 141

if (scalar(@ARGV) == 0) {
  copy("141.108.o01.var", "141.108.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("141.108.o01.txt", "../templates/o01.tpl",
	"../../adt/141/141.demog.1.txt", "141.108.o01.xxx");
mesa_msgs::create_hl7("141.108.o01");

