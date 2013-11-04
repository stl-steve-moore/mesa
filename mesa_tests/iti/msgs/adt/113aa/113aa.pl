#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for PDQ tests 113aa

if (scalar(@ARGV) == 0) {
  copy("abel_6011.var",		"abel_6011.txt");
  copy("david_6012.var",	"david_6012.txt");
  copy("frank_6013.var",	"frank_6013.txt");
  copy("harriet_6014.var",	"harriet_6014.txt");
  copy("francis_6015.var",	"francis_6015.txt");
  copy("arthur_6021.var",	"arthur_6021.txt");
  copy("brad_6022.var",		"brad_6022.txt");
  copy("chad_6023.var",		"chad_6023.txt");
  copy("mary_6024.var",		"mary_6024.txt");
  copy("nidra_6025.var",	"nidra_6025.txt");
} else {
}


  mesa_msgs::create_text_file_2_var_files (
	"113aa.110.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"abel_6011.txt",	# PID, PV1 data
	"113aa.a04.var"		# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.110.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.120.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"david_6012.txt",	# PID, PV1 data
	"113aa.a04.var"		# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.120.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.130.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"frank_6013.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.130.a01");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.140.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"harriet_6014.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.140.a01");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.150.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"francis_6015.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.150.a01");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.160.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"arthur_6021.txt",	# PID, PV1 data
	"113aa.a04.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.160.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.170.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"brad_6022.txt",	# PID, PV1 data
	"113aa.a04.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.170.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.180.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"chad_6023.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.180.a01");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.190.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"mary_6024.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.190.a01");

  mesa_msgs::create_text_file_2_var_files (
	"113aa.200.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A04
	"nidra_6025.txt",	# PID, PV1 data
	"113aa.a01.var"		# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113aa.200.a01");

