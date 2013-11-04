#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 scheduling messages for Case 132

  if (scalar(@ARGV) == 0) {
    copy("132.106.o01.var", "132.106.o01.xxx");
    copy("132.106us.o01.var", "132.106us.o01.xxx");
    copy("132.112.o01.var", "132.112.o01.xxx");
    copy("132.120.o01.var", "132.120.o01.xxx");
    copy("132.120us.o01.var", "132.120us.o01.xxx");
  } else {
  # This was done by an external program.
  }

  mesa_msgs::create_text_file_2_var_files(
	"132.106.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/132/wisteria.txt",	# PID/PV1 information
	"132.106.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("132.106.o01");

  mesa_msgs::create_text_file_2_var_files(
	"132.106us.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/132/wisteria.txt",	# PID/PV1 information
	"132.106us.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("132.106us.o01");

  mesa_msgs::create_text_file_2_var_files(
	"132.112.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/132/wisteria.txt",	# PID/PV1 information
	"132.112.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("132.112.o01");

  mesa_msgs::create_text_file_2_var_files(
	"132.120.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/132/wisteria.txt",	# PID/PV1 information
	"132.120.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("132.120.o01");

  mesa_msgs::create_text_file_2_var_files(
	"132.120us.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template describes a scheduling message
	"../../adt/132/wisteria.txt",	# PID/PV1 information
	"132.120us.o01.xxx");		# Has the OBR, ORC information
  mesa_msgs::create_hl7("132.120us.o01");
