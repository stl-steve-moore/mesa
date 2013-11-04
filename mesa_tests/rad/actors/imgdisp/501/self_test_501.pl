#!/usr/local/bin/perl -w


# Self test for Image Display test 501.

use Env;
use lib "scripts";
require imgdisp;

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "501\\";
  $queryDirectory = "$MESA_STORAGE\\imgmgr\\queries";
} else {
  $dirBase = "501/";
  $queryDirectory = "$MESA_STORAGE/imgmgr/queries";
}

imgdisp::delete_directory("$dirBase" . "cfind_501_1");
imgdisp::create_directory("$dirBase" . "cfind_501_1");


imgdisp::delete_directory("$dirBase" . "cfind_501_2");
imgdisp::create_directory("$dirBase" . "cfind_501_2");

imgdisp::delete_directory("$dirBase" . "cfind_501_3");
imgdisp::create_directory("$dirBase" . "cfind_501_3");

imgdisp::delete_directory("$dirBase" . "cfind_501_4");
imgdisp::create_directory("$dirBase" . "cfind_501_4");

imgdisp::delete_directory("$dirBase" . "cfind_501_5");
imgdisp::create_directory("$dirBase" . "cfind_501_5");

imgdisp::delete_directory("$queryDirectory");
imgdisp::create_directory("$queryDirectory");

imgdisp::make_dcm_object("501/cfind_501_1");
imgdisp::make_dcm_object("501/cfind_501_2");
imgdisp::make_dcm_object("501/cfind_501_3");
imgdisp::make_dcm_object("501/cfind_501_4");
imgdisp::make_dcm_object("501/cfind_501_5");

imgdisp::send_cfind("501/cfind_501_1.dcm", "MESA_IMG_MGR",
		"localhost", "2350", "501/cfind_501_1");

imgdisp::send_cfind("501/cfind_501_2.dcm", "MESA_IMG_MGR",
		"localhost", "2350", "501/cfind_501_2");

imgdisp::send_cfind("501/cfind_501_3.dcm", "MESA_IMG_MGR",
		"localhost", "2350", "501/cfind_501_3");

imgdisp::send_cfind("501/cfind_501_4.dcm", "MESA_IMG_MGR",
		"localhost", "2350", "501/cfind_501_4");

imgdisp::send_cfind("501/cfind_501_5.dcm", "MESA_IMG_MGR",
		"localhost", "2350", "501/cfind_501_5");
