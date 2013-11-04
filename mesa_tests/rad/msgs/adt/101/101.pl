#!/usr/local/bin/perl -w

use Env;

# Generate HL7 messages for Case 101

sub create_text_file {
  `perl $MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0].hl7`;
}


create_text_file("white_x1.var",     "../templates/a04.tpl", "101.tmp");
create_text_file("101.102.a04.var", "101.tmp",              "101.102.a04.txt");
create_hl7("101.102.a04");

create_text_file("101.126.a06.var", "../templates/a06.tpl", "101.tmp");
create_text_file("white_x2.var",    "101.tmp", "101.126.a06.txt");
create_hl7("101.126.a06");

create_text_file("101.128.a06.var", "../templates/a06.tpl", "101.tmp");
create_text_file("white_x2.var",    "101.tmp", "101.128.a06.txt");
create_hl7("101.128.a06");

create_text_file("101.130.a03.var", "../templates/a03.tpl", "101.tmp");
create_text_file("white_x2.var",    "101.tmp", "101.130.a03.txt");
create_hl7("101.130.a03");

create_text_file("101.132.a03.var", "../templates/a03.tpl", "101.tmp");
create_text_file("white_x2.var",    "101.tmp", "101.132.a03.txt");
create_hl7("101.132.a03");

create_text_file("101.160.a04.var", "../templates/a04.tpl", "101.tmp");
create_text_file("doej2.var",       "101.tmp", "101.160.a04.txt");
create_hl7("101.160.a04");

create_text_file("101.161.a40.var", "../templates/a40.tpl", "101.tmp");
create_text_file("doej2.var",       "101.tmp", "101.161.a40.txt");
create_hl7("101.161.a40");

create_text_file("101.166.a40.var", "../templates/a40.tpl", "101.tmp");
create_text_file("white_x3.var",    "101.tmp", "101.166.a40.txt");
create_hl7("101.166.a40");

create_text_file("101.168.a40.var", "../templates/a40.tpl", "101.tmp");
create_text_file("white_x3.var",    "101.tmp", "101.168.a40.txt");
create_hl7("101.168.a40");
