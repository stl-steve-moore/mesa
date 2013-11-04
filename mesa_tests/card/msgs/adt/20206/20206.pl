#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;


# Generate HL7 messages for Case 20206

  if (scalar(@ARGV) == 0) {
    copy("lee.var", "lee.txt");
  } else {
  # The file lee.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"20206.102.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"lee.txt",              # PID, PV1 data
	"20206.102.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20206.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20206.104.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"lee.txt",              # PID, PV1 data
	"20206.104.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20206.104.a04");

