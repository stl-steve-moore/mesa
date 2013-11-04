#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 100

  if (scalar(@ARGV) == 0) {
    copy("king.var", "king.txt");
    copy("queen.var", "queen.txt");
  } else {
  # The files king.txt and queen.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"100.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"king.txt",		# PID, PV1 data
	"100.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("100.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"100.104.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"queen.txt",		# PID, PV1 data
	"100.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("100.104.a04");

