#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1305

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

  print "Please enter name for CALIFORNIA^SACRAMENTO [CALIFORNIA^SACRAMENTO] ->";
  getVariable("\$CALIFORNIA_NAME\$", "CALIFORNIA^SACRAMENTO");
  my $y = "\$CALIFORNIA_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$CALIFORNIA_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidCalifornia = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_CALIFORNIA\$"} = $pidCalifornia . "^^^ADT1";

  my $visitCalifornia = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_CALIFORNIA\$"} = $visitCalifornia . "^^^ADT1";
}

sub process_california {

  # ADT messages for 1305.106, 1305.108
  copy ("adt/1305/california.var", "adt/1305/california.txt");
  open CALIFORNIA, ">>adt/1305/california.txt" or die
	"Could not open adt/1305/california.txt for output\n";
  $x = "\$CALIFORNIA_NAME\$";
  print CALIFORNIA "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$CALIFORNIA_RACE\$";
  print CALIFORNIA "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_CALIFORNIA\$";
  print CALIFORNIA "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_CALIFORNIA\$";
  print CALIFORNIA "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close CALIFORNIA;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_california();

$dir = cwd();
chdir("adt/1305");
print `perl 1305.pl X`;
chdir($dir);

$dir = cwd();
chdir("chg/1305");
print `perl 1305.pl X`;
chdir($dir);

$dir = cwd();
chdir("order/1305");
print `perl 1305.pl X`;
chdir($dir);

$dir = cwd();
chdir("sched/1305");
print `perl 1305.pl X`;
chdir($dir);
