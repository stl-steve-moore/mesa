#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 101

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

#create_text_file("../../adt/101/white_x1.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.106.o01.var",  "101.tmp",              "101.106.o01.txt");

create_text_file_2_var_files("101.106.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x1.var", "101.106.o01.var");
create_hl7("101.106.o01");

#create_text_file("../../adt/101/doej2.var",        "../templates/o01.tpl", "101.tmp");
#create_text_file("101.165.o01.var",  "101.tmp",              "101.165.o01.txt");
create_text_file_2_var_files("101.165.o01.txt", "../templates/o01.tpl",
	"../../adt/101/doej2.var", "101.165.o01.var");
create_hl7("101.165.o01");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.184.o01.var",  "101.tmp",              "101.184.o01.txt");

create_text_file_2_var_files("101.184.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x3.var", "101.184.o01.var");
create_hl7("101.184.o01");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.190.o01.var",  "101.tmp",              "101.190.o01.txt");

create_text_file_2_var_files("101.190.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x3.var", "101.190.o01.var");
create_hl7("101.190.o01");

#create_text_file("../../adt/101/white_x3.var",     "../templates/o01.tpl", "101.tmp");
#create_text_file("101.194.o01.var",  "101.tmp",              "101.194.o01.txt");

create_text_file_2_var_files("101.194.o01.txt", "../templates/o01.tpl",
	"../../adt/101/white_x3.var", "101.194.o01.var");
create_hl7("101.194.o01");

