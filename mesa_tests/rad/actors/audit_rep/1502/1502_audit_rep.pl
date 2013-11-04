#!/usr/local/bin/perl -w

# Test script for test 1502: Audit Record Repository

use Env;
use File::Copy;
use lib "scripts";
require audit;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

sub announce_end {
  print "This is the end of Audit Record Repository Test 1502. \n";
  print " Answer the questions for this test in the file audit_questions.txt \n";
  print " and email that file with your responses to the Project Manager. \n";
}


($syslogPortMESA,
 $syslogHostTest, $syslogPortTest) = audit::read_config_params();

print "Illegal MESA Syslog Port: $syslogPortMESA \n" if ($syslogPortMESA == 0);
print "Illegal Test Syslog Host: $syslogHostTest \n" if ($syslogHostTest eq "");
print "Illegal Test Syslog Port: $syslogPortTest \n" if ($syslogPortTest == 0);

# Three messages from ADT system
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.002", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.004", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.006", "PATIENT_RECORD");

# Two messages from Order Placer system
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.008", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.010", "PATIENT_RECORD");

# Two messages from Order Filler system (schedule P1/X1)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.012", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.014", "PROCEDURE_RECORD");

# Two messages from ADT system (Admit patient)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.016", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.018", "PATIENT_RECORD");

# Modality worklist provided
#audit::create_send_audit($syslogHostTest, $syslogPortTest,
#	"../../msgs/audit/1502/1502.020", "WORKLIST");

# Modality sends images
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.022", "BEGIN_STORING_INSTANCES");

# DICOM Query (C-Find request from Image Display)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.024", "DICOM_QUERY");

# Two messages from Order Placer system (to order P21)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.026", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.028", "PATIENT_RECORD");

# Two messages from Order Filler system (to schedule P21/X21)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.030", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.032", "PATIENT_RECORD");

# Modality worklist provided
#audit::create_send_audit($syslogHostTest, $syslogPortTest,
#	"../../msgs/audit/1502/1502.034", "WORKLIST");

# From Order Filler, cancel of P21/X21
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.036", "PROCEDURE_RECORD");

# Modality worklist provided
#audit::create_send_audit($syslogHostTest, $syslogPortTest,
#	"../../msgs/audit/1502/1502.038", "WORKLIST");

# Two messages from Order Filler system (to order P22)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.040", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.042", "PATIENT_RECORD");

# Two messages from Order Filler system (schedule P22/X22)
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.044", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.046", "PROCEDURE_RECORD");

# Modality worklist provided
#audit::create_send_audit($syslogHostTest, $syslogPortTest,
#	"../../msgs/audit/1502/1502.048", "WORKLIST");

# These are for the discharge
audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.050", "PATIENT_RECORD");

audit::create_send_audit($syslogHostTest, $syslogPortTest,
	"../../msgs/audit/1502/1502.052", "PATIENT_RECORD");

announce_end();

goodbye;

