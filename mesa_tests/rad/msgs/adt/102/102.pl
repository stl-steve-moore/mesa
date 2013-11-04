#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 102

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}


create_text_file("brown_x1.var",     "../templates/a05.tpl", "102.tmp");
create_text_file("102.102.a05.var", "102.tmp",              "102.102.a05.txt");
create_hl7("102.102.a05");

create_text_file("brown_x2.var",     "../templates/a01.tpl", "102.tmp");
create_text_file("102.108.a01.var", "102.tmp",              "102.108.a01.txt");
create_hl7("102.108.a01");

#create_text_file("brown.var",       "../templates/a04.tpl", "102.tmp");
#create_text_file("102.108.a04.var", "102.tmp",              "102.108.a04.txt");
#create_hl7("102.108.a04");

create_text_file("brown_x2.var",     "../templates/a03.tpl", "102.tmp");
create_text_file("102.136.a03.var", "102.tmp",              "102.136.a03.txt");
create_hl7("102.136.a03");

create_text_file("brown_x2.var",     "../templates/a03.tpl", "102.tmp");
create_text_file("102.138.a03.var", "102.tmp",              "102.138.a03.txt");
create_hl7("102.138.a03");

#print `fc 102.102.a05.hl7 D:/temp/102.102.a05.hl7`;
#print `fc 102.108.a01.hl7 D:/temp/102.108.a01.hl7`;
#print `fc 102.108.a04.hl7 D:/temp/102.108.a04.hl7`;
#print `fc 102.136.a03.hl7 D:/temp/102.136.a03.hl7`;
#print `fc 102.138.a03.hl7 D:/temp/102.138.a03.hl7`;
