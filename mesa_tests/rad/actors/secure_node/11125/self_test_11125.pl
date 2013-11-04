#!/usr/local/bin/perl -w

# Self test script for Secure Node test 1205: Audit Messages

use Env;
use File::Copy;
use lib "scripts";
require secure;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$syslogPortMESA = 4000;

# Two messages from ADT system
secure::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/11125/11125.002", "ATNA_PATIENT_RECORD");

secure::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/11125/11125.004", "ATNA_PATIENT_RECORD");

goodbye;

