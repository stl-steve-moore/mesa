#!/usr/local/bin/perl -w
use Env;
use File::Copy;

# Generate HL7 Order messages for Case 131
# This directory is for order messages and does not
# include scheduling messages.

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

if (scalar(@ARGV) == 0) {
  copy("131.104.o01.var", "131.104.o01.xxx");
} else {
# .xxx files provided in an external step
}

create_text_file_2_var_files("131.104.o01.txt", "../templates/o01.tpl",
	"../../adt/131/black.txt", "131.104.o01.xxx");

create_hl7("131.104.o01");
