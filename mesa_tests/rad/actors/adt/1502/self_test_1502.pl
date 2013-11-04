#!/usr/local/bin/perl -w

# Self test script for ADT test 1502: Audit Mesages

use Env;
use File::Copy;
use lib "scripts";
require adt;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$syslogPortMESA = 4000;

# Three messages from ADT system
adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.002", "PATIENT_RECORD");

adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.004", "PATIENT_RECORD");

adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.006", "PATIENT_RECORD");

# Two messages from ADT system (Admit patient)
adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.016", "PATIENT_RECORD");

adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.018", "PATIENT_RECORD");

# These are for the discharge
adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.050", "PATIENT_RECORD");

adt::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.052", "PATIENT_RECORD");

goodbye;

