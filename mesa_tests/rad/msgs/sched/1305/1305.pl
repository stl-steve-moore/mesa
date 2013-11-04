#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 scheduling messages for Case 1305

  if (scalar(@ARGV) == 0) {
    copy("1305.112.o01.var", "1305.112.o01.xxx");
  } else {
  # This was done by an external program.
  }

  mesa_msgs::create_text_file_2_var_files(
	"1305.112.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/1305/california.txt",	# PID/PV1 information
	"1305.112.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("1305.112.o01");

