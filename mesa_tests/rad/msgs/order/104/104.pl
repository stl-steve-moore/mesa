#!/usr/local/bin/perl -w

use Env;

# Generate HL7 Order messages for Case 104
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  print `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

#create_text_file("blue.var",            "../templates/o01.tpl", "104.tmp");
#create_text_file("104.104.o01.var",      "104.tmp",              "104.104.o01.txt");

create_text_file_2_var_files("104.104.o01.txt", "../templates/o01.tpl",
	"../../adt/104/blue.var", "104.104.o01.var");
create_hl7("104.104.o01");

#create_text_file("doej3.var",            "../templates/o01.tpl", "104.tmp");
#create_text_file("104.144.o01.var",      "104.tmp",              "104.144.o01.txt");

create_text_file_2_var_files("104.144.o01.txt", "../templates/o01.tpl",
	"../../adt/104/doej3.var", "104.144.o01.var");
create_hl7("104.144.o01");

#create_text_file("doej3.var",            "../templates/o01.tpl", "104.tmp");
#create_text_file("104.145.o01.var",      "104.tmp",              "104.145.o01.txt");
create_text_file_2_var_files("104.145.o01.txt", "../templates/o01.tpl",
	"../../adt/104/doej3.var", "104.145.o01.var");
create_hl7("104.145.o01");

#create_text_file("doej3.var",            "../templates/o02.tpl", "104.tmp");
#create_text_file("104.146.o02.var",      "104.tmp",              "104.146.o02.txt");
create_text_file_2_var_files("104.146.o02.txt", "../templates/o02.tpl",
	"../../adt/104/doej3.var", "104.146.o02.var");
create_hl7("104.146.o02");
