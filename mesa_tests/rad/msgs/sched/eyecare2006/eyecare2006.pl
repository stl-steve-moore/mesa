#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case Eyecare 2006 demo

if (scalar(@ARGV) == 0) {
  copy("ec.410.o01.var", "ec.410.o01.xxx");
  copy("ec.510.o01.var", "ec.510.o01.xxx");
  copy("ec.610.o01.var", "ec.610.o01.xxx");
  copy("ec.710.o01.var", "ec.710.o01.xxx");
  copy("ec.810.o01.var", "ec.810.o01.xxx");
  copy("ec.910.o01.var", "ec.910.o01.xxx");
  copy("ec.1010.o01.var", "ec.1010.o01.xxx");
  copy("ec.1030.o01.var", "ec.1030.o01.xxx");
  copy("ec.1050.o01.var", "ec.1050.o01.xxx");
  copy("ec.1070.o01.var", "ec.1070.o01.xxx");
  copy("ec.1110.o01.var", "ec.1110.o01.xxx");
  copy("ec.1130.o01.var", "ec.1130.o01.xxx");
  copy("ec.1210.o01.var", "ec.1210.o01.xxx");
  copy("ec.1230.o01.var", "ec.1230.o01.xxx");
  copy("ec.1250.o01.var", "ec.1250.o01.xxx");
} else {
# This was done by an external program.
}

mesa_msgs::create_text_file_2_var_files("ec.410.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/lids.txt", "ec.410.o01.xxx");
mesa_msgs::create_hl7("ec.410.o01");

mesa_msgs::create_text_file_2_var_files("ec.510.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/lids.txt", "ec.510.o01.xxx");
mesa_msgs::create_hl7("ec.510.o01");

mesa_msgs::create_text_file_2_var_files("ec.610.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/iris.txt", "ec.610.o01.xxx");
mesa_msgs::create_hl7("ec.610.o01");

mesa_msgs::create_text_file_2_var_files("ec.710.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/iris.txt", "ec.710.o01.xxx");
mesa_msgs::create_hl7("ec.710.o01");

mesa_msgs::create_text_file_2_var_files("ec.810.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/cornea.txt", "ec.810.o01.xxx");
mesa_msgs::create_hl7("ec.810.o01");

mesa_msgs::create_text_file_2_var_files("ec.910.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/cornea.txt", "ec.910.o01.xxx");
mesa_msgs::create_hl7("ec.910.o01");

mesa_msgs::create_text_file_2_var_files("ec.1010.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1010.o01.xxx");
mesa_msgs::create_hl7("ec.1010.o01");

mesa_msgs::create_text_file_2_var_files("ec.1030.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1030.o01.xxx");
mesa_msgs::create_hl7("ec.1030.o01");

mesa_msgs::create_text_file_2_var_files("ec.1050.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1050.o01.xxx");
mesa_msgs::create_hl7("ec.1050.o01");

mesa_msgs::create_text_file_2_var_files("ec.1070.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/disk.txt", "ec.1070.o01.xxx");
mesa_msgs::create_hl7("ec.1070.o01");

mesa_msgs::create_text_file_2_var_files("ec.1110.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/red.txt", "ec.1110.o01.xxx");
mesa_msgs::create_hl7("ec.1110.o01");

mesa_msgs::create_text_file_2_var_files("ec.1130.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/red.txt", "ec.1130.o01.xxx");
mesa_msgs::create_hl7("ec.1130.o01");

mesa_msgs::create_text_file_2_var_files("ec.1210.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1210.o01.xxx");
mesa_msgs::create_hl7("ec.1210.o01");

mesa_msgs::create_text_file_2_var_files("ec.1230.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1230.o01.xxx");
mesa_msgs::create_hl7("ec.1230.o01");

mesa_msgs::create_text_file_2_var_files("ec.1250.o01.txt", "../templates/o01.tpl",
	"../../adt/eyecare2006/macula.txt", "ec.1250.o01.xxx");
mesa_msgs::create_hl7("ec.1250.o01");
