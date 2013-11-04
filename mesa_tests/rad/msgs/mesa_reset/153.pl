#!/usr/local/bin/perl

# This script updates the HL7 messages for test 153

use Env;
use Cwd;
use File::Copy;
use lib "common";
require mesa_msgs;

sub getVariable {
  my $varName = shift(@_);
  my $defValue= shift(@_);

  my $resp = <STDIN>;
  chomp $resp;
  if ($resp eq "") { $resp = $defValue };
  $varnames{$varName} = $resp;
}

sub readParamsFromStdin {
  print "To enter a <blank> response, enter ####\n";
  print "To keep the default value, enter <Enter> or <Return>\n\n";

  print "Please enter name for PERIWINKLE^JOE [PERIWINKLE^JOE] ->";
  getVariable("\$PERIWINKLE_NAME\$", "PERIWINKLE^JOE");
  my $y = "\$PERIWINKLE_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$PERIWINKLE_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidPeriwinkle = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_PERIWINKLE\$"} = $pidPeriwinkle . "^^^ADT1";

  my $visitPeriwinkle = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_NUMBER\$"} = $visitPeriwinkle . "^^^ADT1";

  $x = "$MESA_TARGET/bin/mesa_identifier adt visit";
  $y = `$x`;
  die "Could not execute mesa_identifier to get VISIT from ADT database \n" if ($?);
  chomp $y;
  $varnames{"\$VISIT\$"} = $y . "^^^ADT1";

  $x = "$MESA_TARGET/bin/mesa_identifier adt account";
  $y = `$x`;
  die "Could not execute mesa_identifier to get ACCOUNT NUMBER from ADT database \n" if ($?);
  chomp $y;
  $varnames{"\$PATIENT_ACCOUNT_NUM\$"} = $y . "^^^ADT1";


  my $placerOrderNumber = mesa_msgs::getNewPlacerOrderNumber("ordplc");
  $varnames{"\$PLACER_ORDER_NUMBER\$"} = $placerOrderNumber . "^MESA_ORDPLC";

  my $fillerAppointmentID = mesa_msgs::getNewAppointmentID("ordfil");
  $varnames{"\$FILLER_APPOINTMENT_ID\$"} = $fillerAppointmentID . "^MESA_ORDFIL";
}

sub process_periwinkle {

  # ADT messages for 153.102, 153.103
  copy ("adt/153/periwinkle.var", "adt/153/periwinkle.txt") or die
	"Could not copy adt/153/periwinkle.var to adt/153/periwinkle.txt\n";
  open PERIWINKLE, ">>adt/153/periwinkle.txt" or die
	"Could not open adt/153/periwinkle.txt for output\n";
  $x = "\$PERIWINKLE_NAME\$";
  print PERIWINKLE "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$PERIWINKLE_RACE\$";
  print PERIWINKLE "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_PERIWINKLE\$";
  print PERIWINKLE "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_NUMBER\$";
  print PERIWINKLE "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print PERIWINKLE "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";
  close PERIWINKLE;

  # Order message, 153.104
  copy ("order/153/153.104.o01.var", "order/153/153.104.o01.xxx");
  open PERIWINKLE , ">>order/153/153.104.o01.xxx" or die
	"Could not open order/153/153.104.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print PERIWINKLE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close PERIWINKLE;

  # Appoint message, 153.106
  copy ("appoint/153/153.106.s12.var", "appoint/153/153.106.s12.xxx");
  open PERIWINKLE , ">>appoint/153/153.106.s12.xxx" or die
	"Could not open appoint/153/153.106.s12.xxx for output\n";
  $x = "\$FILLER_APPOINTMENT_ID\$";
  print PERIWINKLE "\$FILLER_APPOINTMENT_ID\$ = $varnames{$x}\n";
  close PERIWINKLE;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_periwinkle();

$dir = cwd();
chdir("adt/153");
print `perl 153.pl X`;
chdir($dir);

chdir("order/153");
print `perl 153.pl X`;
chdir($dir);

chdir("appoint/153");
print `perl 153.pl X`;
chdir($dir);
