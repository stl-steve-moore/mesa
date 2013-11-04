#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;


# Generate HL7 messages for Case 20102

  if (scalar(@ARGV) == 0) {
    copy("fo.var", "fo.txt");
  } else {
  # The file fo.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"20102.102.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fo.txt",              # PID, PV1 data
	"20102.102.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20102.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20102.104.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fo.txt",              # PID, PV1 data
	"20102.104.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20102.104.a04");

