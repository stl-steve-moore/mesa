#!/usr/local/bin/perl -w
use Env;

# Generate HL7 Order messages for Case 109
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

create_text_file_2_var_files("109.104.o01.txt", "../templates/o01.tpl",
	"../../adt/109/grey.var", "109.104.o01.var");

create_hl7("109.104.o01");
