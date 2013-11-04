#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Eye Care 2006 tests

  if (scalar(@ARGV) == 0) {
    copy("lids.var", "lids.txt");
    copy("iris.var", "iris.txt");
    copy("cornea.var", "cornea.txt");
    copy("disk.var", "disk.txt");
    copy("red.var", "red.txt");
    copy("macula.var", "macula.txt");
  } else {
  # The file lids.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"ec.110.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"lids.txt",             # PID, PV1 data
	"ec.110.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.110.a04");

  mesa_msgs::create_text_file_2_var_files(
	"ec.120.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"iris.txt",             # PID, PV1 data
	"ec.120.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.120.a04");

  mesa_msgs::create_text_file_2_var_files(
	"ec.130.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"cornea.txt",             # PID, PV1 data
	"ec.130.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.130.a04");

  mesa_msgs::create_text_file_2_var_files(
	"ec.140.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"disk.txt",             # PID, PV1 data
	"ec.140.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.140.a04");

  mesa_msgs::create_text_file_2_var_files(
	"ec.150.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"red.txt",             # PID, PV1 data
	"ec.150.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.150.a04");

  mesa_msgs::create_text_file_2_var_files(
	"ec.160.a04.txt",      # The output file
	"../templates/a04.tpl", # Template for an A04
	"macula.txt",             # PID, PV1 data
	"ec.160.a04.var"       # A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("ec.160.a04");
