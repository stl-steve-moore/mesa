#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1303

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

  print "Please enter name for ARIZONA^PHOENIX [ARIZONA^PHOENIX] ->";
  getVariable("\$ARIZONA_NAME\$", "ARIZONA^PHOENIX");
  my $y = "\$ARIZONA_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$ARIZONA_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidArizona = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_ARIZONA\$"} = $pidArizona . "^^^ADT1";

  my $visitArizona = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_ARIZONA\$"} = $visitArizona . "^^^ADT1";
}

sub process_arizona {

  # ADT messages for 1303.106, 1303.108
  copy ("adt/1303/arizona.var", "adt/1303/arizona.txt");
  open ARIZONA, ">>adt/1303/arizona.txt" or die
	"Could not open adt/1303/arizona.txt for output\n";
  $x = "\$ARIZONA_NAME\$";
  print ARIZONA "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$ARIZONA_RACE\$";
  print ARIZONA "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_ARIZONA\$";
  print ARIZONA "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_ARIZONA\$";
  print ARIZONA "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close ARIZONA;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_arizona();

$dir = cwd();
chdir("adt/1303");
print `perl 1303.pl X`;
chdir($dir);

$dir = cwd();
chdir("chg/1303");
print `perl 1303.pl X`;
chdir($dir);

