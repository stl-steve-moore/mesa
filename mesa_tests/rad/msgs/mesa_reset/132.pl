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

  print "Please enter name for Wisteria^Matthew[WISTERIA^MATTHEW] ->";
  getVariable("\$WISTERIA_NAME\$", "WISTERIA^MATTHEW");
  my $y = "\$WISTERIA_NAME\$";
  print "Please enter race for $varnames{$y} [BL] ->";
  getVariable("\$WISTERIA_RACE\$", "WH");
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
  $varnames{"\$PLACER_ORDER_NUMBER_104\$"} = $y . "^MESA_ORDPLC";

  $x = "$MESA_TARGET/bin/mesa_identifier ordfil fon";
  $y = `$x`;
  die "Could not execute mesa_identifier to get Filler Order Number from OF database \n" if ($?);
  chomp $y;
  $varnames{"\$FILLER_ORDER_NUMBER_104\$"} = $y . "^MESA_ORDFIL";

  $x = "$MESA_TARGET/bin/mesa_identifier ordplc pon";
  $y = `$x`;
  die "Could not execute mesa_identifier to get Placer Order Number from OP database \n" if ($?);
  chomp $y;
  $varnames{"\$PLACER_ORDER_NUMBER_116\$"} = $y . "^MESA_ORDPLC";

  $x = "$MESA_TARGET/bin/mesa_identifier ordfil fon";
  $y = `$x`;
  die "Could not execute mesa_identifier to get Filler Order Number from OF database \n" if ($?);
  chomp $y;
  $varnames{"\$FILLER_ORDER_NUMBER_116\$"} = $y . "^MESA_ORDFIL";
}

sub process_wisteria {
  copy ("adt/131/wisteria.var", "adt/131/wisteria.txt");
  open WISTERIA, ">>adt/132/wisteria.txt" or die
	"Could not open adt/132/wisteria.txt for output\n";
  $x = "\$WISTERIA_NAME\$";
  print WISTERIA "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$WISTERIA_RACE\$";
  print WISTERIA "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID\$";
  print WISTERIA "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT\$";
  print WISTERIA "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("order/132/132.104.o01.var", "order/132/132.104.o01.xxx");
  open WISTERIA, ">>order/132/132.104.o01.xxx" or die
	"Could not open order/132/132.104.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_104\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("sched/132/132.106.o01.var", "sched/132/132.106.o01.xxx");
  open WISTERIA, ">>sched/132/132.106.o01.xxx" or die
	"Could not open sched/132/132.106.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_104\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER_104\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("order/132/132.110.o01x.var", "order/132/132.110.o01x.xxx");
  open WISTERIA, ">>order/132/132.110.o01x.xxx" or die
	"Could not open order/132/132.110.o01x.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_104\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER_104\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("sched/132/132.112.o01.var", "sched/132/132.112.o01.xxx");
  open WISTERIA, ">>sched/132/132.112.o01.xxx" or die
	"Could not open sched/132/132.112.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_104\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER_104\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("order/132/132.116.o01.var", "order/132/132.116.o01.xxx");
  open WISTERIA, ">>order/132/132.116.o01.xxx" or die
	"Could not open order/132/132.116.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER_116\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("order/132/132.118.o02.var", "order/132/132.118.o02.xxx");
  open WISTERIA, ">>order/132/132.118.o02.xxx" or die
	"Could not open order/132/132.118.o02.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_116\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER_116\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("order/132/132.119.o01.var", "order/132/132.119.o01.xxx");
  open WISTERIA, ">>order/132/132.119.o01.xxx" or die
	"Could not open order/132/132.119.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_116\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;

  copy ("sched/132/132.120.o01.var", "sched/132/132.120.o01.xxx");
  open WISTERIA, ">>sched/132/132.120.o01.xxx" or die
	"Could not open sched/132/132.120.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER_116\$";
  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER_116\$";
  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close WISTERIA;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_wisteria();

$dir = cwd();
chdir("adt/132");
print `perl 132.pl X`;
chdir($dir);

chdir("order/132");
print `perl 132.pl X`;
chdir($dir);

chdir("sched/132");
print `perl 132.pl X`;
chdir($dir);
