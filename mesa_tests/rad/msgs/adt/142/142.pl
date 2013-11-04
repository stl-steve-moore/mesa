#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 142

  if (scalar(@ARGV) == 0) {
    copy("142.demog.1.var", "142.demog.1.txt");
  } else {
  # The file 142.demog.1.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"142.102.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"142.demog.1.txt",	# PID, PV1 data
	"142.102.a01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("142.102.a01");


  mesa_msgs::create_text_file_2_var_files(
	"142.104.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"142.demog.1.txt",	# PID, PV1 data
	"142.104.a01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("142.104.a01");

  mesa_msgs::create_text_file_2_var_files(
	"142.142.a03.txt",	# The output file
	"../templates/a03.tpl",	# Template for an A01
	"142.demog.1.txt",	# PID, PV1 data
	"142.142.a03.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("142.142.a03");

  mesa_msgs::create_text_file_2_var_files(
	"142.144.a03.txt",	# The output file
	"../templates/a03.tpl",	# Template for an A01
	"142.demog.1.txt",	# PID, PV1 data
	"142.144.a03.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("142.144.a03");

