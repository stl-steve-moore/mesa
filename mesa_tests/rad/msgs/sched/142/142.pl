#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 scheduling messages for Case 142

  if (scalar(@ARGV) == 0) {
    copy("142.108.o01.var", "142.108.o01.xxx");
    copy("142.112.o01.var", "142.112.o01.xxx");
    copy("142.120.o01.var", "142.120.o01.xxx");
  } else {
  # This was done by an external program.
  }

  mesa_msgs::create_text_file_2_var_files(
	"142.108.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/142/142.demog.1.txt",# PID/PV1 information
	"142.108.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("142.108.o01");

  mesa_msgs::create_text_file_2_var_files(
	"142.112.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/142/142.demog.1.txt",# PID/PV1 information
	"142.112.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("142.112.o01");


  mesa_msgs::create_text_file_2_var_files(
	"142.120.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/142/142.demog.1.txt",# PID/PV1 information
	"142.120.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("142.120.o01");
