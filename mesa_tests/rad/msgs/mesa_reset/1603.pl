#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1603

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

  print "Please enter name for LINCOLN^ABRAHAM [LINCOLN^ABRAHAM] ->";
  getVariable("\$LINCOLN_NAME\$", "LINCOLN^ABRAHAM");
  my $y = "\$LINCOLN_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$LINCOLN_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidLincoln = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_LINCOLN\$"} = $pidLincoln . "^^^ADT1";

  my $visitLincoln = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_LINCOLN\$"} = $visitLincoln . "^^^ADT1";
}

sub process_lincoln {

  # ADT messages for 1603.102, 1603.104
  copy ("adt/1603/lincoln.var", "adt/1603/lincoln.txt");
  open LINCOLN, ">>adt/1603/lincoln.txt" or die
	"Could not open adt/1603/lincoln.txt for output\n";
  $x = "\$LINCOLN_NAME\$";
  print LINCOLN "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$LINCOLN_RACE\$";
  print LINCOLN "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_LINCOLN\$";
  print LINCOLN "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_LINCOLN\$";
  print LINCOLN "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close LINCOLN;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_lincoln();

$dir = cwd();
chdir("adt/1603");
print `perl 1603.pl X`;
chdir($dir);

