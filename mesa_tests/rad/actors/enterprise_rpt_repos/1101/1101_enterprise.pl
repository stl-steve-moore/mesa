#!/usr/local/bin/perl -w

# Runs the Enterprise Report Repository 1101 test.
use Env;
use lib "scripts";
require report;

# (debug mode is selected over verbose if both are present)
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}


sub announce_test {
  print
"\n" .
"This is Enterprise Report Repository test 1101.\n";
}

sub announce_create_report {
  print
"\n" .
"First step is to create the HL7 Report from a DICOM Structured Report\n";
}

sub announce_end {
  print
"This script has sent an HL7 report for the patient CRTHREE^PAUL. \n" .
" You should render this report and send it to the Project Manager.\n";
}


# Erase old files

sub clear_mesa {
  `perl scripts/reset_servers.pl`;
}

#Set Machine names and port numbers

print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($reposHost, $reposPort) = report::read_config_params();

clear_mesa;

announce_test;
announce_create_report;

report::convert_sr_to_hl7("../../msgs/sr/601/sr_601cr.dcm", "1101/sr_601cr.hl7", "msh.txt");
report::add_universal_service_id("1101/sr_601cr.hl7", "P1^Procedure P1^ERL_MESA");

$x = report::send_hl7("1101", "sr_601cr.hl7", $reposHost, $reposPort);
report::xmit_error("sr_601cr.hl7") if ($x == 0);

announce_end;

goodbye;
