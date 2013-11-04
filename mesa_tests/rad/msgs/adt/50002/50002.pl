#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 50002

  if (scalar(@ARGV) == 0) {
    copy("branson.var", "branson.txt");
    copy("springfield.var", "springfield.txt");
  } else {
  # The file branson.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"50002.110.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"branson.txt",              # PID, PV1 data
	"50002.110.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50002.110.a04");

  mesa_msgs::create_text_file_2_var_files(
	"50002.120.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"branson.txt",              # PID, PV1 data
	"50002.120.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50002.120.a04");

  mesa_msgs::create_text_file_2_var_files(
	"50002.180.a08.txt",      # The output file
	"../templates/a08.tpl", # Template for an A04
	"springfield.txt",              # PID, PV1 data
	"50002.180.a08.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50002.180.a08");

  mesa_msgs::create_text_file_2_var_files(
	"50002.190.a08.txt",      # The output file
	"../templates/a08.tpl", # Template for an A04
	"springfield.txt",              # PID, PV1 data
	"50002.190.a08.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50002.190.a08");

  mesa_msgs::create_text_file_2_var_files(
	"50002.200.a08.txt",      # The output file
	"../templates/a08.tpl", # Template for an A04
	"springfield.txt",              # PID, PV1 data
	"50002.200.a08.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("50002.200.a08");

