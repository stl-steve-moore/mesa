#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 133

  if (scalar(@ARGV) == 0) {
    copy("indigo.var", "indigo.txt");
    copy("doe.var", "doe.txt");
  } else {
  # The file indigo.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"133.102.a04.txt", 	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"indigo.txt",		# PID, PV1 data
	"133.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"133.103.a04.txt", 	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"indigo.txt",		# PID, PV1 data
	"133.103.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.103.a04");

  mesa_msgs::create_text_file_2_var_files(
	"133.142.a04.txt", 	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"doe.txt",		# PID, PV1 data
	"133.142.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.142.a04");

  mesa_msgs::create_text_file_2_var_files(
	"133.143.a04.txt", 	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"doe.txt",		# PID, PV1 data
	"133.143.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.143.a04");

  mesa_msgs::create_text_file_2_var_files(
	"133.182.a40.txt", 	# The output file
	"../templates/a40.tpl",	# Template for an A40
	"indigo.txt",		# PID, PV1 data
	"133.182.a40.var"	# A40 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.182.a40");

  mesa_msgs::create_text_file_2_var_files(
	"133.183.a40.txt", 	# The output file
	"../templates/a40.tpl",	# Template for an A40
	"indigo.txt",		# PID, PV1 data
	"133.183.a40.var"	# A40 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.183.a40");

  mesa_msgs::create_text_file_2_var_files(
	"133.184.a40.txt", 	# The output file
	"../templates/a40.tpl",	# Template for an A40
	"indigo.txt",		# PID, PV1 data
	"133.184.a40.var"	# A40 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("133.184.a40");


