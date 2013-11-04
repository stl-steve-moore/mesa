#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 102

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}

#create_text_file("../../adt/102/brown.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.106.o01.var",          "102.tmp",              "102.106.o01.txt");

create_text_file_2_var_files("102.106.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x1.var", "102.106.o01.var");
create_hl7("102.106.o01");

#create_text_file("../../adt/102/brown.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.124.o01.var",          "102.tmp",              "102.124.o01.txt");

create_text_file_2_var_files("102.124.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.124.o01.var");
create_hl7("102.124.o01");

#create_text_file("../../adt/102/brown.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.128.o01.var",          "102.tmp",              "102.128.o01.txt");

create_text_file_2_var_files("102.128.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.128.o01.var");
create_hl7("102.128.o01");

#create_text_file("../../adt/102/brown.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.134.o01.var",          "102.tmp",              "102.134.o01.txt");

create_text_file_2_var_files("102.134.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.134.o01.var");
create_hl7("102.134.o01");
