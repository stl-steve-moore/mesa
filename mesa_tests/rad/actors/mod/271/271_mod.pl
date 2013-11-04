#!/usr/local/bin/perl -w

# Script manages Modality Test 271
# This modifies the patient name in the MWL.

use Env;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
 print
"\n" .
"This is Modality Test 271. One Scheduled Procedure Step should \n" .
" exist in the MWL for patient with ID MM271. In this test, you \n" .
" will query the MWL for that patient, update the patient name, \n" .
" and then query again. You should see the new name after your query.\n";
}

sub request_first_query {
  print
"\n" .
"Please query the MWL now. This is the query before the patient update\n" .
" Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_new_name {
 print
"\n" .
"Please enter a new name for the patient for this test: ";
  my $response = <STDIN>;
  chomp $response;
  return $response;
}

sub announce_end {
 print "\n" .
"The MWL should have been updated; the script output should show \n" .
" the new patient name for the patient with ID MM271. If the script \n" .
" output looks correct, query the MWL again and make sure you receive \n" .
" the updated name. If the MWL entry is wrong, file a bug report \n" .
" for this test.\n\n".
" There is no evaluation for this test.\n";
}

# =================================================
# Main starts here

announce_test;

request_first_query;

$newName = request_new_name;

print "name: $newName \n";

mod::update_mwl("where patid = 'MM271'", "set nam = '$newName'");

announce_end;

goodbye;
