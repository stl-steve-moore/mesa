#!/usr/local/bin/perl

# This script updates the HL7 messages for test 107

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

  print "Please enter name for Rose^Carl [ROSE^CARL] ->";
  getVariable("\$ROSE_NAME\$", "ROSE^CARL");
  my $y = "\$ROSE_NAME\$";
  print "Please enter race for $varnames{$y} [BL] ->";
  getVariable("\$ROSE_RACE\$", "BL");
}

sub get_new_identifiers()
{
  my $x = "$MESA_TARGET/bin/mesa_identifier adt pid";
  my $y = `$x`;
  die "Could not execute mesa_identifier to get PID from ADT database \n" if ($?);
  chomp $y;
  $varnames{"\$PID\$"} = $y . "^^^ADT1";

  $x = "$MESA_TARGET/bin/mesa_identifier adt visit";
  $y = `$x`;
  die "Could not execute mesa_identifier to get VISIT from ADT database \n" if ($?);
  chomp $y;
  $varnames{"\$VISIT\$"} = $y . "^^^ADT1";

  $x = "$MESA_TARGET/bin/mesa_identifier ordplc pon";
  $y = `$x`;
  die "Could not execute mesa_identifier to get Placer Order Number from OP database \n" if ($?);
  chomp $y;
  $varnames{"\$PLACER_ORDER_NUMBER\$"} = $y . "^MESA_ORDPLC";

  $x = "$MESA_TARGET/bin/mesa_identifier ordfil fon";
  $y = `$x`;
  die "Could not execute mesa_identifier to get Filler Order Number from OF database \n" if ($?);
  chomp $y;
  $varnames{"\$FILLER_ORDER_NUMBER\$"} = $y . "^MESA_ORDFIL";
}

sub process_rose {
  copy ("adt/131/rose.var", "adt/131/rose.txt");
  open ROSE, ">>adt/131/rose.txt" or die
	"Could not open adt/131/rose.txt for output\n";
  $x = "\$ROSE_NAME\$";
  print ROSE "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$ROSE_RACE\$";
  print ROSE "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID\$";
  print ROSE "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT\$";
  print ROSE "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  close ROSE;

  copy ("order/107/107.104.o01.var", "order/107/107.104.o01.xxx");
  open ROSE, ">>order/107/107.104.o01.xxx" or die
	"Could not open order/107/107.104.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print ROSE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close ROSE;

  copy ("sched/107/107.106.o01.var", "sched/107/107.106.o01.xxx");
  open ROSE, ">>sched/107/107.106.o01.xxx" or die
	"Could not open sched/107/107.106.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print ROSE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print ROSE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close ROSE;

  copy ("status/107/107.112.o01.var", "status/107/107.112.o01.xxx");
  open ROSE, ">>status/107/107.112.o01.xxx" or die
	"Could not open status/107/107.112.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print ROSE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print ROSE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close ROSE;

  copy ("status/107/107.116.o01.var", "status/107/107.116.o01.xxx");
  open ROSE, ">>status/107/107.116.o01.xxx" or die
	"Could not open status/107/107.116.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print ROSE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print ROSE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close ROSE;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_rose();

$dir = cwd();
chdir("adt/107");
print `perl 107.pl X`;
chdir($dir);

chdir("order/107");
print `perl 107.pl X`;
chdir($dir);

chdir("sched/107");
print `perl 107.pl X`;
chdir($dir);

chdir("status/107");
print `perl 107.pl X`;
chdir($dir);
