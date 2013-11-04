#!/usr/local/bin/perl -w

# Test script for test 1502: Audit Record Repository

use Env;
use Cwd;
use File::Copy;
use lib "scripts";
require ordfil;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

$syslogPortMESA = 4000;

# Two messages from Order Filler system (schedule P1/X1)
ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.012", "PATIENT_RECORD");

ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.014", "PROCEDURE_RECORD");

# Modality worklist provided
#ordfil::create_send_audit("localhost", $syslogPortMESA,
#	"../../msgs/audit/1502/1502.020", "WORKLIST");

# Two messages from Order Filler system (to schedule P21/X21)
ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.030", "PATIENT_RECORD");

ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.032", "PATIENT_RECORD");

# Modality worklist provided
#ordfil::create_send_audit("localhost", $syslogPortMESA,
#	"../../msgs/audit/1502/1502.034", "WORKLIST");

# From Order Filler, cancel of P21/X21
ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.036", "PROCEDURE_RECORD");

# Modality worklist provided
#ordfil::create_send_audit("localhost", $syslogPortMESA,
#	"../../msgs/audit/1502/1502.038", "WORKLIST");

# Two messages from Order Filler system (to order P22)
ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.040", "PATIENT_RECORD");

ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.042", "PATIENT_RECORD");

# Two messages from Order Filler system (schedule P22/X22)
ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.044", "PATIENT_RECORD");

ordfil::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1502/1502.046", "PROCEDURE_RECORD");

# Modality worklist provided
#ordfil::create_send_audit("localhost", $syslogPortMESA,
#	"../../msgs/audit/1502/1502.048", "WORKLIST");

goodbye;

