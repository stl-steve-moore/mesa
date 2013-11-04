#!/usr/local/bin/perl -w

use Env;

# Generate HL7 Order messages for HIMSS 2004 Modality test  cases

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

create_text_file("../../adt/himss-2004/tumor.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("tumor.104.o01.var",      "2xx.tmp",              "tumor.104.o01.txt");
create_hl7("tumor.104.o01");

create_text_file("../../adt/himss-2004/tumor.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("tumor.106.o01.var",      "2xx.tmp",              "tumor.106.o01.txt");
create_hl7("tumor.106.o01");

