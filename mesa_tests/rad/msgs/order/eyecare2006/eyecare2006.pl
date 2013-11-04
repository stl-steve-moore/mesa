#!/usr/local/bin/perl -w
use Env;
use File::Copy;

# Generate HL7 Order messages for Case 50000
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
  copy("ec.400.o01.var", "ec.400.o01.xxx");
  copy("ec.500.o01.var", "ec.500.o01.xxx");
  copy("ec.600.o01.var", "ec.600.o01.xxx");
  copy("ec.700.o01.var", "ec.700.o01.xxx");
  copy("ec.800.o01.var", "ec.800.o01.xxx");
  copy("ec.900.o01.var", "ec.900.o01.xxx");
  copy("ec.1000.o01.var", "ec.1000.o01.xxx");
  copy("ec.1020.o01.var", "ec.1020.o01.xxx");
  copy("ec.1040.o01.var", "ec.1040.o01.xxx");
  copy("ec.1060.o01.var", "ec.1060.o01.xxx");
  copy("ec.1100.o01.var", "ec.1100.o01.xxx");
  copy("ec.1120.o01.var", "ec.1120.o01.xxx");
  copy("ec.1200.o01.var", "ec.1200.o01.xxx");
  copy("ec.1220.o01.var", "ec.1220.o01.xxx");
  copy("ec.1240.o01.var", "ec.1240.o01.xxx");
} else {
# .xxx files provided in an external step
}

create_text_file_2_var_files("ec.400.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/lids.txt", "ec.400.o01.xxx");
create_hl7("ec.400.o01");

create_text_file_2_var_files("ec.500.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/lids.txt", "ec.500.o01.xxx");
create_hl7("ec.500.o01");

create_text_file_2_var_files("ec.600.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/iris.txt", "ec.600.o01.xxx");
create_hl7("ec.600.o01");

create_text_file_2_var_files("ec.700.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/iris.txt", "ec.700.o01.xxx");
create_hl7("ec.700.o01");

create_text_file_2_var_files("ec.800.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/cornea.txt", "ec.800.o01.xxx");
create_hl7("ec.800.o01");

create_text_file_2_var_files("ec.900.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/cornea.txt", "ec.900.o01.xxx");
create_hl7("ec.900.o01");

create_text_file_2_var_files("ec.1000.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1000.o01.xxx");
create_hl7("ec.1000.o01");

create_text_file_2_var_files("ec.1020.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1020.o01.xxx");
create_hl7("ec.1020.o01");

create_text_file_2_var_files("ec.1040.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1040.o01.xxx");
create_hl7("ec.1040.o01");

create_text_file_2_var_files("ec.1060.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1060.o01.xxx");
create_hl7("ec.1060.o01");

create_text_file_2_var_files("ec.1100.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/red.txt", "ec.1100.o01.xxx");
create_hl7("ec.1100.o01");

create_text_file_2_var_files("ec.1120.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/red.txt", "ec.1120.o01.xxx");
create_hl7("ec.1120.o01");

create_text_file_2_var_files("ec.1200.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1200.o01.xxx");
create_hl7("ec.1200.o01");

create_text_file_2_var_files("ec.1220.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1220.o01.xxx");
create_hl7("ec.1220.o01");

create_text_file_2_var_files("ec.1240.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1240.o01.xxx");
create_hl7("ec.1240.o01");
