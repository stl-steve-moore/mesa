#!/usr/local/bin/perl -w


# Self test for Report Reader test 901-j.

use Env;
use lib "scripts";
require rpt_reader;

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "901-j\\";
  $queryDirectory = "$MESA_STORAGE\\rpt_repos\\queries";
} else {
  $dirBase = "901-j/";
  $queryDirectory = "$MESA_STORAGE/rpt_repos/queries";
}

rpt_reader::delete_directory("$dirBase" . "cfind_901_1");
rpt_reader::create_directory("$dirBase" . "cfind_901_1");


rpt_reader::delete_directory("$dirBase" . "cfind_901_2");
rpt_reader::create_directory("$dirBase" . "cfind_901_2");

rpt_reader::delete_directory("$dirBase" . "cfind_901_3");
rpt_reader::create_directory("$dirBase" . "cfind_901_3");

rpt_reader::delete_directory("$dirBase" . "cfind_901_4");
rpt_reader::create_directory("$dirBase" . "cfind_901_4");

rpt_reader::delete_directory("$dirBase" . "cfind_901_5");
rpt_reader::create_directory("$dirBase" . "cfind_901_5");

rpt_reader::delete_directory("$queryDirectory");
rpt_reader::create_directory("$queryDirectory");

rpt_reader::make_dcm_object("901-j/cfind_901_1");
rpt_reader::make_dcm_object("901-j/cfind_901_2");
rpt_reader::make_dcm_object("901-j/cfind_901_3");
rpt_reader::make_dcm_object("901-j/cfind_901_4");
rpt_reader::make_dcm_object("901-j/cfind_901_5");

rpt_reader::send_cfind("901-j/cfind_901_1.dcm", "MESA_RPT_REPOS",
		"localhost", "2800", "901-j/cfind_901_1");

rpt_reader::send_cfind("901-j/cfind_901_2.dcm", "MESA_RPT_REPOS",
		"localhost", "2800", "901-j/cfind_901_2");

rpt_reader::send_cfind("901-j/cfind_901_3.dcm", "MESA_RPT_REPOS",
		"localhost", "2800", "901-j/cfind_901_3");

rpt_reader::send_cfind("901-j/cfind_901_4.dcm", "MESA_RPT_REPOS",
		"localhost", "2800", "901-j/cfind_901_4");

rpt_reader::send_cfind("901-j/cfind_901_5.dcm", "MESA_RPT_REPOS",
		"localhost", "2800", "901-j/cfind_901_5");
