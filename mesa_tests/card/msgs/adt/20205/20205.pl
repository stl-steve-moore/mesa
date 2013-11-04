#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;


# Generate HL7 messages for Case 20205

  if (scalar(@ARGV) == 0) {
    copy("doe.var", "doe.txt");
    copy("fischer.var", "fischer.txt");
  } else {
  # The file fe.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"20205.102a.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"doe.txt",              # PID, PV1 data
	"20205.102a.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.102a.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20205.102.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fischer.txt",              # PID, PV1 data
	"20205.102.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20205.104.a04.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fischer.txt",              # PID, PV1 data
	"20205.104.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.104.a04");

  mesa_msgs::create_text_file_2_var_files(
	"20205.175.a08.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a04.tpl", # Template for an A04
	"fischer.txt",              # PID, PV1 data
	"20205.175.a08.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.175.a08");

  mesa_msgs::create_text_file_2_var_files(
	"20205.184.a40.txt",      # The output file
	"../../../../rad/msgs/adt/templates/a40.tpl", # Template for an A40
	"fischer.txt",              # PID, PV1 data
	"20205.184.a40.var"       # A40 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20205.184.a40");
