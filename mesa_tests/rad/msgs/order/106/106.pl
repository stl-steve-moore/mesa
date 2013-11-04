#!/usr/local/bin/perl -w

use Env;

# Generate HL7 Order messages for 106 series tests
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  print `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

#create_text_file("../../adt/106/green.var","../templates/o01.tpl", "106.tmp");
#create_text_file("106.104.o01.var",      "106.tmp",              "106.104.o01.txt");

create_text_file_2_var_files("106.104.o01.txt", "../templates/o01.tpl",
	"../../adt/106/green.var", "106.104.o01.var");
create_hl7("106.104.o01");

#create_text_file("../../adt/106/green.var","../templates/o01.tpl", "106.tmp");
#create_text_file("106.106.o01.var",      "106.tmp",              "106.106.o01.txt");

create_text_file_2_var_files("106.106.o01.txt", "../templates/o01.tpl",
	"../../adt/106/green.var", "106.106.o01.var");
create_hl7("106.106.o01");
