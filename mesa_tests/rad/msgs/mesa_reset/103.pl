#!/usr/local/bin/perl

# This script updates the HL7 messages for test 103

use Env;
use Cwd;
use File::Copy;

sub readParamsFromFile {
  my $f = shift(@_);
  open(TESTVARS, $f) or die "Can't open $f \n";
  while ($line = <TESTVARS>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
#    $varvalue = "" if ($varvalue =~ /####/);
    $varnames{$varname} = $varvalue;
  }
  close (TESTVARS);
}

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

  print "Please enter name for Doe [DOE^J1] ->";
  getVariable("\$DOE_NAME\$", "DOE^J1");
  print "Please enter race for Doe [WH] ->";
  getVariable("\$DOE_RACE\$", "WH");
  print "Please enter name for Silverheels [SILVERHEELS^JAY] ->";
  getVariable("\$SILVERHEELS_NAME\$", "SILVERHEELS^JAY");
  print "Please enter race for Silverheels [WH] ->";
  getVariable("\$SILVERHEELS_RACE\$", "WH");
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

  $x = "$MESA_TARGET/bin/mesa_identifier adt account";
  $y = `$x`;
  die "Could not execute mesa_identifier to get ACCOUNT NUMBER from ADT database \n" if ($?);
  chomp $y;
  $varnames{"\$PATIENT_ACCOUNT_NUM\$"} = $y . "^^^ADT1";

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

sub process_doe {
  copy ("adt/103/doej1.var", "adt/103/doej1.txt");
  open DOE, ">>adt/103/doej1.txt" or die
	"Could not open adt/103/doej1.txt for output\n";
  $x = "\$DOE_NAME\$";
  print DOE "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$DOE_RACE\$";
  print DOE "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID\$";
  print DOE "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT\$";
  print DOE "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print DOE "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";
  close DOE;

  copy ("order/103/103.104.o01.var", "order/103/103.104.o01.xxx");
  open DOE, ">>order/103/103.104.o01.xxx" or die
	"Could not open order/103/103.104.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  copy ("sched/103/103.106.o01.var", "sched/103/103.106.o01.xxx");
  open DOE, ">>sched/103/103.106.o01.xxx" or die
	"Could not open sched/103/103.106.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;
}

sub process_silverheels {
  copy ("adt/103/silverheels.var", "adt/103/silverheels.txt");
  open SILVERHEELS, ">>adt/103/silverheels.txt" or die
	"Could not open adt/103/silverheels.txt for output\n";
  $x = "\$SILVERHEELS_NAME\$";
  print SILVERHEELS "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$SILVERHEELS_RACE\$";
  print SILVERHEELS "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID\$";
  print SILVERHEELS "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT\$";
  print SILVERHEELS "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PATIENT_ACCOUNT_NUM\$";
  print SILVERHEELS "\$PATIENT_ACCOUNT_NUM\$ = $varnames{$x}\n";
  close SILVERHEELS;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_doe();
process_silverheels();

$dir = cwd();
chdir("adt/103");
print `perl 103.pl X`;
chdir($dir);

chdir("order/103");
print `perl 103.pl X`;
chdir($dir);

chdir("sched/103");
print `perl 103.pl X`;
chdir($dir);
