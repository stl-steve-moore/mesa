#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 101
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}


#create_text_file("../../adt/101/white_x1.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.104.o01.var",  "101.tmp",              "101.104.o01.txt");

create_text_file_2_var_files("101.104.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x1.var", "101.104.o01.var");
create_hl7("101.104.o01");

#create_text_file("../../adt/101/doej2.var",        "../templates/o01.tpl", "101.tmp");
#create_text_file("101.162.o01.var",  "101.tmp",              "101.162.o01.txt");
create_text_file_2_var_files("101.162.o01.txt", "../templates/o01.tpl",
	"../../adt/101/doej2.var", "101.162.o01.var");
create_hl7("101.162.o01");

#create_text_file("../../adt/101/doej2.var",        "../templates/o02.tpl", "101.tmp");
#create_text_file("101.164.o02.var",  "101.tmp",              "101.164.o02.txt");
create_text_file_2_var_files("101.164.o02.txt", "../templates/o02.tpl",
	"../../adt/101/doej2.var", "101.164.o02.var");
create_hl7("101.164.o02");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.182.o01.var",  "101.tmp",              "101.182.o01.txt");
create_text_file_2_var_files("101.182.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x3.var", "101.182.o01.var");
create_hl7("101.182.o01");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01x.tpl", "101.tmp");
#create_text_file("101.188.o01x.var", "101.tmp",               "101.188.o01x.txt");
create_text_file_2_var_files("101.188.o01x.txt", "../templates/o01x.tpl",
	"../../adt/101/white_x3.var", "101.188.o01x.var");
create_hl7("101.188.o01x");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.192.o01.var",  "101.tmp",              "101.192.o01.txt");
create_text_file_2_var_files("101.192.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x3.var", "101.192.o01.var");
create_hl7("101.192.o01");
