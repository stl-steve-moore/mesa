#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 50004

  if (scalar(@ARGV) == 0) {
    copy("york.var", "york.txt");
  } else {
  # The file york.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"50004.110.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"york.txt",              # PID, PV1 data
	"50004.110.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50004.110.a04");

  mesa_msgs::create_text_file_2_var_files(
	"50004.120.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"york.txt",              # PID, PV1 data
	"50004.120.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50004.120.a04");

