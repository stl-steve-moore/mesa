#!/usr/local/bin/perl

# This script updates the HL7 messages for test 131

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

  print "Please enter name for Black^Charles [BLACK^CHARLES] ->";
  getVariable("\$BLACK_NAME\$", "BLACK^CHARLES");
  my $y = "\$BLACK_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$BLACK_RACE\$", "WH");
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

sub process_black {
  copy ("adt/131/black.var", "adt/131/black.txt");
  open BLACK, ">>adt/131/black.txt" or die
	"Could not open adt/131/black.txt for output\n";
  $x = "\$BLACK_NAME\$";
  print BLACK "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$BLACK_RACE\$";
  print BLACK "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID\$";
  print BLACK "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT\$";
  print BLACK "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  close BLACK;

  copy ("order/131/131.104.o01.var", "order/131/131.104.o01.xxx");
  open BLACK, ">>order/131/131.104.o01.xxx" or die
	"Could not open order/131/131.104.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print BLACK "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close BLACK;

  copy ("sched/131/131.106.o01.var", "sched/131/131.106.o01.xxx");
  open BLACK, ">>sched/131/131.106.o01.xxx" or die
	"Could not open sched/131/131.106.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print BLACK "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print BLACK "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close BLACK;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_black();

$dir = cwd();
chdir("adt/131");
print `perl 131.pl X`;
chdir($dir);

chdir("order/131");
print `perl 131.pl X`;
chdir($dir);

chdir("sched/131");
print `perl 131.pl X`;
chdir($dir);
