#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 104

sub create_text_file_2_var_files {
  print `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}

#create_text_file("blue.var",             "../templates/o01_3sps.tpl", "104.tmp");
#create_text_file("104.106.o01_3sps.var", "104.tmp",                   "104.106.o01.txt");

create_text_file_2_var_files("104.106.o01.txt", "../templates/o01_3sps.tpl",
	"../../adt/104/blue.var", "104.106.o01_3sps.var");
create_hl7("104.106.o01");

#create_text_file("doej3.var",             "../templates/o01.tpl",      "104.tmp");
#create_text_file("104.148.o01.var",      "104.tmp",                   "104.148.o01.txt");

create_text_file_2_var_files("104.148.o01.txt", "../templates/o01.tpl",
	"../../adt/104/doej3.var", "104.148.o01.var");
create_hl7("104.148.o01");
