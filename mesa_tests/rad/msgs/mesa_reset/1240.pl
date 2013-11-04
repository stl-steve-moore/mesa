#!/usr/local/bin/perl

# This script updates the HL7 messages for test 1240

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

  print "Please enter name for BOSTON^BOB [BOSTON^BOB] ->";
  getVariable("\$BOSTON_NAME\$", "BOSTON^BOB");
  my $y = "\$BOSTON_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$BOSTON_RACE\$", "WH");
}

sub get_new_identifiers()
{
  my $pidBoston = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_BOSTON\$"} = $pidBoston . "^^^ADT1";

  my $visitBoston = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_BOSTON\$"} = $visitBoston . "^^^ADT1";
}

sub process_boston {

  # ADT messages for 1240.102, 1240.104
  copy ("adt/1240/boston.var", "adt/1240/boston.txt");
  open BOSTON, ">>adt/1240/boston.txt" or die
	"Could not open adt/1240/boston.txt for output\n";
  $x = "\$BOSTON_NAME\$";
  print BOSTON "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$BOSTON_RACE\$";
  print BOSTON "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_BOSTON\$";
  print BOSTON "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_BOSTON\$";
  print BOSTON "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  close BOSTON;
}

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_boston();

$dir = cwd();
chdir("adt/1240");
print `perl 1240.pl X`;
chdir($dir);

