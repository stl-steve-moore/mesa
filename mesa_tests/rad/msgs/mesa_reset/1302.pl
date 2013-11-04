#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1302

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

  print "Please enter name for ALASKA^JUNEAU [ALASKA^JUNEAU] ->";
  getVariable("\$ALASKA_NAME\$", "ALASKA^JUNEAU");
  my $y = "\$ALASKA_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$ALASKA_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidAlaska = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_ALASKA\$"} = $pidAlaska . "^^^ADT1";

  my $visitAlaska = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_ALASKA\$"} = $visitAlaska . "^^^ADT1";
}

sub process_alaska {

  # ADT messages for 1302.106, 1302.108
  copy ("adt/1302/alaska.var", "adt/1302/alaska.txt");
  open ALASKA, ">>adt/1302/alaska.txt" or die
	"Could not open adt/1302/alaska.txt for output\n";
  $x = "\$ALASKA_NAME\$";
  print ALASKA "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$ALASKA_RACE\$";
  print ALASKA "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_ALASKA\$";
  print ALASKA "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_ALASKA\$";
  print ALASKA "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close ALASKA;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_alaska();

$dir = cwd();
chdir("adt/1302");
print `perl 1302.pl X`;
chdir($dir);

$dir = cwd();
chdir("chg/1302");
print `perl 1302.pl X`;
chdir($dir);

