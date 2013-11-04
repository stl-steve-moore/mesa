#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 messages for Case 20108

if (scalar(@ARGV) == 0) {
  copy("20108.108.o01.var", "20108.108.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("20108.108.o01.txt", "../../../../rad/msgs/sched/templates/o01.tpl",
	"../../adt/20108/perry.txt", "20108.108.o01.xxx");
mesa_msgs::create_hl7("20108.108.o01");
