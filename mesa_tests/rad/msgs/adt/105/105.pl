#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 105

  if (scalar(@ARGV) == 0) {
    copy("doe.var", "doe.txt");
    copy("mustard.var", "mustard.txt");
  } else {
  # The files doe.txt and mustard.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"105.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"doe.txt",		# PID, PV1 data
	"105.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("105.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"105.103.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"doe.txt",		# PID, PV1 data
	"105.103.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("105.103.a04");

  mesa_msgs::create_text_file_2_var_files(
	"105.120.a08.txt",	# The output file
	"../templates/a08.tpl",	# Template for an A08
	"mustard.txt",		# PID, PV1 data
	"105.120.a08.var"	# A08 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("105.120.a08");

  mesa_msgs::create_text_file_2_var_files(
	"105.121.a08.txt",	# The output file
	"../templates/a08.tpl",	# Template for an A08
	"mustard.txt",		# PID, PV1 data
	"105.121.a08.var"	# A08 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("105.121.a08");

  mesa_msgs::create_text_file_2_var_files(
	"105.122.a08.txt",	# The output file
	"../templates/a08.tpl",	# Template for an A08
	"mustard.txt",		# PID, PV1 data
	"105.122.a08.var"	# A08 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("105.122.a08");

