#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 1601

# add these to this file until common/mesa_msgs.pm is added to repository
  if (scalar(@ARGV) == 0) {
    copy("1601.108.o01.var", "1601.108.o01.xxx");
    copy("1601.109.o01.var", "1601.109.o01.xxx");
  } else {
  # This was done by an external program.
  }

  mesa_msgs::create_text_file_2_var_files(
	"1601.108.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/1601/washington.txt", # PID/PV1 information
	"1601.108.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("1601.108.o01");

  mesa_msgs::create_text_file_2_var_files(
	"1601.109.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/1601/washington.txt", # PID/PV1 information
	"1601.109.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("1601.109.o01");

