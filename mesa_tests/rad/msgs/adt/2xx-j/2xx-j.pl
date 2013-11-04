#!/usr/local/bin/perl -w

use Env;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Modality Cases 2xx


  mesa_msgs::create_text_file_2_var_files(
	"211.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"211.var",			# PID and PV1 information
	"211.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("211.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"213.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"213.var",			# PID and PV1 information
	"213.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("213.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"221.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"221.var",			# PID and PV1 information
	"221.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("221.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"222.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"222.var",			# PID and PV1 information
	"222.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("222.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"231.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"231.var",			# PID and PV1 information
	"231.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("231.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"241.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"241.var",			# PID and PV1 information
	"241.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("241.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"242.102.a04.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"242.var",			# PID and PV1 information
	"242.102.a04.var");		# ADT variable file
  mesa_msgs::create_hl7("242.102.a04");

exit 0;

exit 0;

create_text_file("214.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("214.102.a04.var", "2xx.tmp",              "214.102.a04.txt");
create_hl7("214.102.a04");

create_text_file("215.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("215.102.a04.var", "2xx.tmp",              "215.102.a04.txt");
create_hl7("215.102.a04");

create_text_file("218.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("218.102.a04.var", "2xx.tmp",              "218.102.a04.txt");
create_hl7("218.102.a04");

create_text_file("271.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("271.102.a04.var", "2xx.tmp",              "271.102.a04.txt");
create_hl7("271.102.a04");
