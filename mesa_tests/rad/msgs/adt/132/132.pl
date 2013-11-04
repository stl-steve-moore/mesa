#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 132

  if (scalar(@ARGV) == 0) {
    copy("wisteria.var", "wisteria.txt");
  } else {
  # The file wisteria.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"132.102.a01.txt", 	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"wisteria.txt",		# PID, PV1 data
	"132.102.a01.var"	# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("132.102.a01");

  mesa_msgs::create_text_file_2_var_files(
	"132.103.a01.txt", 	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"wisteria.txt",		# PID, PV1 data
	"132.103.a01.var"	# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("132.103.a01");

  mesa_msgs::create_text_file_2_var_files(
	"132.142.a03.txt", 	# The output file
	"../templates/a03.tpl",	# Template for an A01
	"wisteria.txt",		# PID, PV1 data
	"132.142.a03.var"	# A03 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("132.142.a03");

  mesa_msgs::create_text_file_2_var_files(
	"132.143.a03.txt", 	# The output file
	"../templates/a03.tpl",	# Template for an A01
	"wisteria.txt",		# PID, PV1 data
	"132.143.a03.var"	# A03 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("132.143.a03");
