#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

sub processLine {
  my ($l, $msgNumber) = @_;
  my ($pid, $name, $dob, $streetAddress, $city, $state, $zip, $secondID, $sex, $race, $referring) = split("\t", $l);
  print "$pid:$name:$dob:$referring\n";

  open A04TEMPLATE, "<a04_demographics.var" or die "Could not open input file: a04_demographics.var\n";
  open A04VAR, ">a04.var" or die "Could not open var file: a04.var\n";
  while ($x = <A04TEMPLATE>) {
    print A04VAR "$x";
  }
  close A04TEMPLATE;
  print A04VAR "\$MESSAGE_CONTROL_ID\$ = $msgNumber\n";
  print A04VAR "\$CHARSET\$ = ####\n";
  print A04VAR "\$PATIENT_ID\$ = $pid\n";
  print A04VAR "\$PATIENT_NAME\$ = $name\n";
  print A04VAR "\$DATE_TIME_BIRTH\$ = $dob\n";
  print A04VAR "\$SEX\$ = $sex\n";
  print A04VAR "\$RACE\$ = $race\n";
  print A04VAR "\$PATIENT_ADDRESS\$ = $streetAddress^^$city^$state^$zip\n";
  print A04VAR "\$PATIENT_ACCOUNT_NUM\$ = $pid\n";
  print A04VAR "\$PATIENT_CLASS\$ = O\n";
  print A04VAR "\$REFERRING_DOCTOR\$ = $referring\n";
  print A04VAR "\$VISIT_NUMBER\$ = $msgNumber^METRO\n";
  print A04VAR "\$ADMIT_DATE_TIME\$ = ####\n";
  print A04VAR "\$VISIT_INDICATOR\$ = V\n";
  close A04VAR;

  mesa_msgs::create_text_file_2_var_files(
	"$msgNumber.txt",	# Output file
	"../templates/a04.tpl",	# Template for A04
	"empty.var",
	"a04.var");
  mesa_msgs::create_hl7("$msgNumber");

  open A04VAR, ">>a04.var" or die "Could not open var file for 2nd ID: a04.var\n";
  print A04VAR "\$PATIENT_ID\$ = $secondID\n";
  close A04VAR;

  $msgNumber += 1;
  mesa_msgs::create_text_file_2_var_files(
	"$msgNumber.txt",	# Output file
	"../templates/a04.tpl",	# Template for A04
	"empty.var",
	"a04.var");
  mesa_msgs::create_hl7("$msgNumber");

  return 0;
}

if (scalar(@ARGV) != 1) {
  die "Usage: script <input file>\n";
}

my $inFile = $ARGV[0];
open IN, "<$inFile" or die "Could not open input file: $inFile\n";

my $msgNumber = 1000;
$line = <IN>;
while ($line = <IN>) {
  chomp($line);
  processLine($line, $msgNumber);
  $msgNumber += 2;
}

