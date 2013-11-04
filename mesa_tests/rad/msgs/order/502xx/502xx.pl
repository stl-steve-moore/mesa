#!/usr/local/bin/perl -w

use Env;

# Generate HL7 Order messages for Modality 2xx cases

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

create_text_file("../../adt/502xx/50202.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("50202.120.o01.var",      "2xx.tmp",              "50202.120.o01.txt");
create_hl7("50202.120.o01");

#create_text_file("../../adt/2xx/213.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("213.104.o01.var",      "2xx.tmp",              "213.104.o01.txt");
#create_hl7("213.104.o01");
#
#create_text_file("../../adt/2xx/214.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("214.104.o01.var",      "2xx.tmp",              "214.104.o01.txt");
#create_hl7("214.104.o01");

create_text_file("../../adt/502xx/50215.var","../templates/o01.tpl", "2xx.tmp");
create_text_file("50215.120.o01.var",      "2xx.tmp",              "50215.120.o01.txt");
create_hl7("50215.120.o01");

#create_text_file("../../adt/2xx/218.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("218.104.o01.var",      "2xx.tmp",              "218.104.o01.txt");
#create_hl7("218.104.o01");
#
#create_text_file("../../adt/2xx/221.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("221.104.o01.var",      "2xx.tmp",              "221.104.o01.txt");
#create_hl7("221.104.o01");
#
#create_text_file("../../adt/2xx/222.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("222.104.o01.var",      "2xx.tmp",              "222.104.o01.txt");
#create_hl7("222.104.o01");
#
#create_text_file("../../adt/2xx/222.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("222.106.o01.var",      "2xx.tmp",              "222.106.o01.txt");
#create_hl7("222.106.o01");
#
#create_text_file("../../adt/2xx/231.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("231.104.o01.var",      "2xx.tmp",              "231.104.o01.txt");
#create_hl7("231.104.o01");
#
#create_text_file("../../adt/2xx/241.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("241.104.o01.var",      "2xx.tmp",              "241.104.o01.txt");
#create_hl7("241.104.o01");
#
#create_text_file("../../adt/2xx/242.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("242.104.o01.var",      "2xx.tmp",              "242.104.o01.txt");
#create_hl7("242.104.o01");
#
#create_text_file("../../adt/2xx/271.var","../templates/o01.tpl", "2xx.tmp");
#create_text_file("271.104.o01.var",      "2xx.tmp",              "271.104.o01.txt");
#create_hl7("271.104.o01");
