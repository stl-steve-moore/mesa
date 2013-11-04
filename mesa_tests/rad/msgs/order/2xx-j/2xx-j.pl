#!/usr/local/bin/perl -w

use Env;

use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Modality 2xx cases


  mesa_msgs::create_text_file_2_var_files(
	"211.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/211.var",	# PID and PV1 information
	"211.104.o01.var",		# Variables for 211.104 message
  );
  mesa_msgs::create_hl7("211.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"213.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/213.var",	# PID and PV1 information
	"213.104.o01.var",		# Variables for 213.104 message
  );
  mesa_msgs::create_hl7("213.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"221.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/221.var",	# PID and PV1 information
	"221.104.o01.var",		# Variables for 221.104 message
  );
  mesa_msgs::create_hl7("221.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"222.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/222.var",	# PID and PV1 information
	"222.104.o01.var",		# Variables for 222.104 message
  );
  mesa_msgs::create_hl7("222.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"222.106.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/222.var",	# PID and PV1 information
	"222.106.o01.var",		# Variables for 222.106 message
  );
  mesa_msgs::create_hl7("222.106.o01");

  mesa_msgs::create_text_file_2_var_files(
	"231.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/231.var",	# PID and PV1 information
	"231.104.o01.var",		# Variables for 231.104 message
  );
  mesa_msgs::create_hl7("231.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"241.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/241.var",	# PID and PV1 information
	"241.104.o01.var",		# Variables for 241.104 message
  );
  mesa_msgs::create_hl7("241.104.o01");

  mesa_msgs::create_text_file_2_var_files(
	"242.104.o01.txt",		# Output file
	"../templates/o01.tpl",		# Template file
	"../../adt/2xx-j/242.var",	# PID and PV1 information
	"242.104.o01.var",		# Variables for 242.104 message
  );
  mesa_msgs::create_hl7("242.104.o01");

exit 0;

create_text_file("../../adt/2xx/213.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("213.104.o01.var",      "2xx.tmp",              "213.104.o01.txt");
create_hl7("213.104.o01");

create_text_file("../../adt/2xx/214.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("214.104.o01.var",      "2xx.tmp",              "214.104.o01.txt");
create_hl7("214.104.o01");

create_text_file("../../adt/2xx/215.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("215.104.o01.var",      "2xx.tmp",              "215.104.o01.txt");
create_hl7("215.104.o01");

create_text_file("../../adt/2xx/218.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("218.104.o01.var",      "2xx.tmp",              "218.104.o01.txt");
create_hl7("218.104.o01");

create_text_file("../../adt/2xx/222.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("222.104.o01.var",      "2xx.tmp",              "222.104.o01.txt");
create_hl7("222.104.o01");

create_text_file("../../adt/2xx/222.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("222.106.o01.var",      "2xx.tmp",              "222.106.o01.txt");
create_hl7("222.106.o01");

create_text_file("../../adt/2xx/271.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("271.104.o01.var",      "2xx.tmp",              "271.104.o01.txt");
create_hl7("271.104.o01");
