#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for PDQ tests 113xx

if (scalar(@ARGV) == 0) {
  copy("moore_domain1.var",		"moore_domain1.txt");
  copy("moore_ralph_domain1.var",	"moore_ralph_domain1.txt");
  copy("mohr.var",			"mohr.txt");
  copy("moody.var",			"moody.txt");
  copy("mooney.var",			"mooney.txt");
  copy("sanders_d1.var",		"sanders_d1.txt");
  copy("rendel_d1.var",			"rendel_d1.txt");
  copy("ferguson_d1.var",		"ferguson_d1.txt");
  copy("sanders_d2.var",		"sanders_d2.txt");
  copy("rendel_d2.var",			"rendel_d2.txt");
  copy("ferguson_d2.var",		"ferguson_d2.txt");
#  copy("alpha_domain2.var",   "alpha_domain2.txt");
#  copy("simpson_domain1.var", "simpson_domain1.txt");
} else {
# The files would have been produced externally
#  alpha_domain1.txt
#  alpha_domain2.txt
#  simpson_domain1.txt
}


  mesa_msgs::create_text_file_2_var_files (
	"113xx.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"moore_domain1.txt",	# PID, PV1 data
	"113xx.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.102.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.104.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"moore_ralph_domain1.txt",	# PID, PV1 data
	"113xx.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.104.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.106.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"mohr.txt",	# PID, PV1 data
	"113xx.106.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.106.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.108.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"moody.txt",	# PID, PV1 data
	"113xx.108.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.108.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.110.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"mooney.txt",	# PID, PV1 data
	"113xx.110.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.110.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.112.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"sanders_d1.txt",	# PID, PV1 data
	"113xx.112.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.112.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.114.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"rendel_d1.txt",	# PID, PV1 data
	"113xx.114.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.114.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.116.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"ferguson_d1.txt",	# PID, PV1 data
	"113xx.116.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.116.a04");


  mesa_msgs::create_text_file_2_var_files (
	"113xx.140.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"sanders_d2.txt",	# PID, PV1 data
	"113xx.140.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.140.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.150.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"rendel_d2.txt",	# PID, PV1 data
	"113xx.150.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.150.a04");

  mesa_msgs::create_text_file_2_var_files (
	"113xx.160.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"ferguson_d2.txt",	# PID, PV1 data
	"113xx.160.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("113xx.160.a04");

