#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;


# Generate HL7 messages for Case 20101

  if (scalar(@ARGV) == 0) {
    copy("fe.var", "fe.txt");
  } else {
  # The file fe.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"20101.102.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fe.txt",              # PID, PV1 data
	"20101.102.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20101.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20101.104.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fe.txt",              # PID, PV1 data
	"20101.104.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20101.104.a04");

