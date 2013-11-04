#!/usr/local/bin/perl -w

use Env;

# Generate HL7 Order messages for Case 102
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  print `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}


#create_text_file("../../adt/102/brown_x1.var",   "../templates/o01.tpl", "102.tmp");
#create_text_file("102.104.o01.var",      "102.tmp",              "102.104.o01.txt");

create_text_file_2_var_files("102.104.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x1.var", "102.104.o01.var");
create_hl7("102.104.o01");

#create_text_file("../../adt/102/brown_x2.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.122.o01.var",     "102.tmp",              "102.122.o01.txt");
create_text_file_2_var_files("102.122.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.122.o01.var");
create_hl7("102.122.o01");

#create_text_file("../../adt/102/brown_x2.var",  "../templates/o01x.tpl", "102.tmp");
#create_text_file("102.126.o01x.var",     "102.tmp",               "102.126.o01x.txt");

create_text_file_2_var_files("102.126.o01x.txt", "../templates/o01x.tpl",
	"../../adt/102/brown_x2.var", "102.126.o01x.var");
create_hl7("102.126.o01x");

#create_text_file("../../adt/102/brown_x2.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.130.o01.var",      "102.tmp",              "102.130.o01.txt");

create_text_file_2_var_files("102.130.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.130.o01.var");
create_hl7("102.130.o01");

#create_text_file("../../adt/102/brown_x2.var",  "../templates/o01.tpl", "102.tmp");
#create_text_file("102.131.o01.var",      "102.tmp",              "102.131.o01.txt");

create_text_file_2_var_files("102.131.o01.txt", "../templates/o01.tpl",
	"../../adt/102/brown_x2.var", "102.131.o01.var");
create_hl7("102.131.o01");

#create_text_file("../../adt/102/brown_x2.var",  "../templates/o02.tpl", "102.tmp");
#create_text_file("102.132.o02.var",      "102.tmp",              "102.132.o02.txt");

create_text_file_2_var_files("102.132.o02.txt", "../templates/o02.tpl",
	"../../adt/102/brown_x2.var", "102.132.o02.var");
create_hl7("102.132.o02");
