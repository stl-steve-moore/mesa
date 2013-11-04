#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1301

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

  print "Please enter name for ALABAMA^MONTGOMERY [ALABAMA^MONTGOMERY] ->";
  getVariable("\$ALABAMA_NAME\$", "ALABAMA^MONTGOMERY");
  my $y = "\$ALABAMA_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$ALABAMA_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidAlabama = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_ALABAMA\$"} = $pidAlabama . "^^^ADT1";

  my $visitAlabama = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_ALABAMA\$"} = $visitAlabama . "^^^ADT1";
}

sub process_alabama {

  # ADT messages for 1302.102, 1302.103
  copy ("adt/1301/alabama.var", "adt/1301/alabama.txt");
  open ALABAMA, ">>adt/1301/alabama.txt" or die
	"Could not open adt/1301/alabama.txt for output\n";
  $x = "\$ALABAMA_NAME\$";
  print ALABAMA "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$ALABAMA_RACE\$";
  print ALABAMA "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_ALABAMA\$";
  print ALABAMA "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_ALABAMA\$";
  print ALABAMA "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close ALABAMA;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_alabama();

$dir = cwd();
chdir("adt/1301");
print `perl 1301.pl X`;
chdir($dir);

$dir = cwd();
chdir("chg/1301");
print `perl 1301.pl X`;
chdir($dir);

