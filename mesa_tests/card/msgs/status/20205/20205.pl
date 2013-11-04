#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

  # Generate HL7 Status messages for 20205 series tests
  if (scalar(@ARGV) == 0) {
    copy("20205.160.o01.var", "20205.160.o01.xxx");
    copy("20205.180.o01.var", "20205.180.o01.xxx");
  } else {
    # .xxx files provided in an external step
  }

  mesa_msgs::create_text_file_2_var_files(
	"20205.160.o01.txt",	# The output file
	"../../../../rad/msgs/sched/templates/o01.tpl",	# Template for an O01
	"../../adt/20205/fischer.txt",# PID, PV1 data
	"20205.160.o01.xxx"	# O01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.160.o01");

  mesa_msgs::create_text_file_2_var_files(
	"20205.180.o01.txt",	# The output file
	"../../../../rad/msgs/sched/templates/o01.tpl",	# Template for an O01
	"../../adt/20205/fischer.txt",# PID, PV1 data
	"20205.180.o01.xxx"	# O01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.180.o01");

