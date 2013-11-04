#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Modality Cases 2xx

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}

create_text_file("50202.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("50202.110.a04.var", "2xx.tmp",              "50202.110.a04.txt");
create_hl7("50202.110.a04");

#create_text_file("213.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("213.102.a04.var", "2xx.tmp",              "213.102.a04.txt");
#create_hl7("213.102.a04");

#create_text_file("214.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("214.102.a04.var", "2xx.tmp",              "214.102.a04.txt");
#create_hl7("214.102.a04");

create_text_file("50215.var",         "../templates/a04.tpl", "2xx.tmp");
create_text_file("50215.110.a04.var", "2xx.tmp",              "50215.110.a04.txt");
create_hl7("50215.110.a04");

#create_text_file("218.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("218.102.a04.var", "2xx.tmp",              "218.102.a04.txt");
#create_hl7("218.102.a04");
#
#create_text_file("221.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("221.102.a04.var", "2xx.tmp",              "221.102.a04.txt");
#create_hl7("221.102.a04");
#
#create_text_file("222.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("222.102.a04.var", "2xx.tmp",              "222.102.a04.txt");
#create_hl7("222.102.a04");
#
#create_text_file("231.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("231.102.a04.var", "2xx.tmp",              "231.102.a04.txt");
#create_hl7("231.102.a04");
#
#create_text_file("241.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("241.102.a04.var", "2xx.tmp",              "241.102.a04.txt");
#create_hl7("241.102.a04");
#
#create_text_file("242.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("242.102.a04.var", "2xx.tmp",              "242.102.a04.txt");
#create_hl7("242.102.a04");
#
#create_text_file("271.var",         "../templates/a04.tpl", "2xx.tmp");
#create_text_file("271.102.a04.var", "2xx.tmp",              "271.102.a04.txt");
#create_hl7("271.102.a04");
