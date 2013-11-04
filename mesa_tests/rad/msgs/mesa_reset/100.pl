#!/usr/local/bin/perl

# This script updates the HL7 messages for test 100

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

  print "Please enter name for QUEEN^MARY [QUEEN^MARY] ->";
  getVariable("\$QUEEN_NAME\$", "QUEEN^MARY");
  my $y = "\$QUEEN_NAME\$";
  print "Please enter race for $varnames{$y} [AP] ->";
  getVariable("\$QUEEN_RACE\$", "AP");

  print "Please enter name for KING^JJ105[KING^JJ105 ->";
  getVariable("\$KING_NAME\$", "KING^J105");
}

sub get_new_identifiers()
{
  my $pidKing = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_KING\$"} = $pidKing . "^^^ADT1";

  my $visitKing = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_NUMBER\$"} = $visitKing . "^^^ADT1";

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

sub process_king {

  # ADT messages for 100.102, 100.104
  copy ("adt/100/king.var", "adt/100/king.txt");
  open KING, ">>adt/100/king.txt" or die
	"Could not open adt/100/king.txt for output\n";
  $x = "\$KING_NAME\$";
  print KING "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$QUEEN_RACE\$";
  print KING "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_KING\$";
  print KING "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_NUMBER\$";
  print KING "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print KING "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";
  close KING;

  # Order message, 100.106
  copy ("order/100/100.106.o01.var", "order/100/100.106.o01.xxx");
  open KING , ">>order/100/100.106.o01.xxx" or die
	"Could not open order/100/100.106.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print KING "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close KING;

  # Order message, 100.108
  copy ("order/100/100.108.o01.var", "order/100/100.108.o01.xxx");
  open KING , ">>order/100/100.108.o01.xxx" or die
	"Could not open order/100/100/108.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print KING "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print KING "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close KING;

  # Order message, 100.110
  copy ("order/100/100.110.o01.var", "order/100/100.110.o01.xxx");
  open KING , ">>order/100/100.110.o01.xxx" or die
	"Could not open order/100/100/110.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print KING "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print KING "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close KING;

  # Order message, 100.112
  copy ("order/100/100.112.o01.var", "order/100/100.112.o01.xxx");
  open KING , ">>order/100/100.112.o01.xxx" or die
	"Could not open order/100/100/112.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print KING "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print KING "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close KING;
}

sub process_queen {

  # ADT messages for 100.102, 100.104
  copy ("adt/100/queen.var", "adt/100/queen.txt");
  open QUEEN, ">>adt/100/queen.txt" or die
	"Could not open adt/100/queen.txt for output\n";
  $x = "\$QUEEN_NAME\$";
  print QUEEN "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$QUEEN_RACE\$";		# Yes, use the same race
  print QUEEN "\$RACE\$ = $varnames{$x}\n";

  $x = "\$PID_KING\$";		# Yes, use the same PID
  print QUEEN "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_NUMBER\$";
  print QUEEN "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print QUEEN "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";

  close QUEEN;

#
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_king();
process_queen();

$dir = cwd();
chdir("adt/100");
print `perl 100.pl X`;
chdir($dir);

chdir("order/100");
print `perl 100.pl X`;
chdir($dir);

chdir("sched/100");
print `perl 100.pl X`;
chdir($dir);
