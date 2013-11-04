#!/usr/local/bin/perl

# This script updates the HL7 messages for test 105

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

  print "Please enter name for MUSTARD^STEPHEN [MUSTARD^STEPHEN] ->";
  getVariable("\$MUSTARD_NAME\$", "MUSTARD^STEPHEN");
  my $y = "\$MUSTARD_NAME\$";
  print "Please enter race for $varnames{$y} [AP] ->";
  getVariable("\$MUSTARD_RACE\$", "AP");

  print "Please enter name for DOE^JJ105[DOE^JJ105 ->";
  getVariable("\$DOE_NAME\$", "DOE^J105");
}

sub get_new_identifiers()
{
  my $pidDoe = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_DOE\$"} = $pidDoe . "^^^ADT1";

  my $visitDoe = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_NUMBER\$"} = $visitDoe . "^^^ADT1";

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

  my $fillerOrderNumber = mesa_msgs::getNewFillerOrderNumber("ordfil");
  $varnames{"\$FILLER_ORDER_NUMBER\$"} = $fillerOrderNumber . "^MESA_ORDFIL";
}

sub process_doe {

  # ADT messages for 105.102, 105.103
  copy ("adt/105/doe.var", "adt/105/doe.txt");
  open DOE, ">>adt/105/doe.txt" or die
	"Could not open adt/105/doe.txt for output\n";
  $x = "\$DOE_NAME\$";
  print DOE "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$MUSTARD_RACE\$";
  print DOE "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_DOE\$";
  print DOE "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_NUMBER\$";
  print DOE "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print DOE "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";
  close DOE;

  # Order message, 105.144
  copy ("order/105/105.114.o01.var", "order/105/105.114.o01.xxx");
  open DOE , ">>order/105/105.114.o01.xxx" or die
	"Could not open order/105/105.114.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  # Order message, 105.116
  copy ("order/105/105.116.o02.var", "order/105/105.116.o02.xxx");
  open DOE , ">>order/105/105.116.o02.xxx" or die
	"Could not open order/105/105/116.o02.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  copy ("order/105/105.117.o01.var", "order/105/105.117.o01.xxx");
  open DOE , ">>order/105/105.117.o01.xxx" or die
	"Could not open order/105/105.117.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  # Scheduling message, 105.148
  copy ("sched/105/105.118.o01.var", "sched/105/105.118.o01.xxx");
  open DOE , ">>sched/105/105.118.o01.xxx" or die
	"Could not open sched/105/105.118.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;
}

sub process_mustard {

  # ADT messages for 105.102, 105.103
  copy ("adt/105/mustard.var", "adt/105/mustard.txt");
  open MUSTARD, ">>adt/105/mustard.txt" or die
	"Could not open adt/105/mustard.txt for output\n";
  $x = "\$MUSTARD_NAME\$";
  print MUSTARD "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$MUSTARD_RACE\$";		# Yes, use the same race
  print MUSTARD "\$RACE\$ = $varnames{$x}\n";

  $x = "\$PID_DOE\$";		# Yes, use the same PID
  print MUSTARD "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_NUMBER\$";
  print MUSTARD "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print MUSTARD "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";

  close MUSTARD;

#
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_doe();
process_mustard();

$dir = cwd();
chdir("adt/105");
print `perl 105.pl X`;
chdir($dir);

chdir("order/105");
print `perl 105.pl X`;
chdir($dir);

chdir("sched/105");
print `perl 105.pl X`;
chdir($dir);
