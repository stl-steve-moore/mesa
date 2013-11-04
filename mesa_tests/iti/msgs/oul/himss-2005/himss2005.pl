#!/usr/local/bin/perl -w
use Env;
use File::Copy;

# Generate HL7 Order messages for HIMSS 2005 test messages.

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe-iti -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

if (scalar(@ARGV) == 0) {
  copy("himss2005.102.r24.var", "himss2005.102.r24.xxx");
  copy("demographics.var",      "demographics.xxx");
} else {
# .xxx files provided in an external step
}

create_text_file_2_var_files("himss2005.102.r24.txt", "../templates/r24.tpl",
	"demographics.xxx", "himss2005.102.r24.xxx");

create_hl7("himss2005.102.r24");
