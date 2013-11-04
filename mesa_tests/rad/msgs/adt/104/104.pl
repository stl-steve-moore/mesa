#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 104

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}


create_text_file("blue.var",       "../templates/a04.tpl", "104.tmp");
create_text_file("104.102.a04.var", "104.tmp",             "104.102.a04.txt");
create_hl7("104.102.a04");

#create_text_file("blue.var",       "../templates/a03.tpl", "104.tmp");
#create_text_file("104.120.a03.var", "104.tmp",             "104.120.a03.txt");
#create_hl7("104.120.a03");
#
#create_text_file("blue.var",       "../templates/a03.tpl", "104.tmp");
#create_text_file("104.122.a03.var", "104.tmp",             "104.122.a03.txt");
#create_hl7("104.122.a03");

create_text_file("doej3.var",       "../templates/a04.tpl", "104.tmp");
create_text_file("104.142.a04.var", "104.tmp",             "104.142.a04.txt");
create_hl7("104.142.a04");

create_text_file("blue.var",       "../templates/a40.tpl", "104.tmp");
create_text_file("104.182.a40.var", "104.tmp",             "104.182.a40.txt");
create_hl7("104.182.a40");

create_text_file("blue.var",       "../templates/a40.tpl", "104.tmp");
create_text_file("104.184.a40.var", "104.tmp",             "104.184.a40.txt");
create_hl7("104.184.a40");

#create_text_file("blue.var",       "../templates/a03.tpl", "104.tmp");
#create_text_file("104.186.a03.var", "104.tmp",             "104.186.a03.txt");
#create_hl7("104.186.a03");
#
#create_text_file("blue.var",       "../templates/a03.tpl", "104.tmp");
#create_text_file("104.188.a03.var", "104.tmp",             "104.188.a03.txt");
#create_hl7("104.188.a03");

#print `fc 104.102.a04.hl7 D:/temp/104.102.a04.hl7`;
#print `fc 104.120.a03.hl7 D:/temp/104.120.a03.hl7`;
#print `fc 104.122.a03.hl7 D:/temp/104.122.a03.hl7`;
#print `fc 104.142.a04.hl7 D:/temp/104.142.a04.hl7`;
#print `fc 104.182.a40.hl7 D:/temp/104.182.a40.hl7`;
#print `fc 104.184.a40.hl7 D:/temp/104.184.a40.hl7`;
#print `fc 104.186.a03.hl7 D:/temp/104.186.a03.hl7`;
#print `fc 104.188.a03.hl7 D:/temp/104.188.a03.hl7`;
