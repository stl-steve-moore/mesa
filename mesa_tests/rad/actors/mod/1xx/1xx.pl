#!/usr/local/bin/perl -w

# Creates MWL and comparison data for Modality 1xx tests.

use Env;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_start {
  print "\n" .
"This is the setup script for Modality 1xx series tests. \n" .
" This script creates MWL entries and comparison data. \n" .
" It is a one-time script (but won't be harmed if you run it again).\n";
}

sub announce_106 {
  print "\n" .
  "Producing data for 106 test (PGP).\n\n";
}

sub produce_106_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/106", "106.102.a04.hl7", "localhost", "2200");
  mod::xmit_error("106.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/106", "106.104.o01.hl7", "localhost", "2200");
  mod::xmit_error("106.104.o01.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/106", "106.106.o01.hl7", "localhost", "2200");
  mod::xmit_error("106.106.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 106 for $modAE:$mod \n" if ($?);

  $x =  "perl scripts/produce_group_2rp.pl MR MODALITY1 583050 " .
	" T106 MESA localhost 2250 X6_A1 X7_A1 X6-7 MR/MR4/MR4S1";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce T106 images \n" if ($?);

 $x = "perl scripts/produce_scheduled_gsps.pl PR MODALITY1 " .
	" 583050 P6 T106_gsps_x6 MESA localhost 2250 X6_A1 X6 " .
	" T106 106/options_x6.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X6) \n" if ($?);

 $x = "perl scripts/produce_scheduled_gsps.pl PR MODALITY1 " .
	" 583050 P7 T106_gsps_x7 MESA localhost 2250 X7_A1 X7 " .
	" T106 106/options_x7.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X7) \n" if ($?);

}



# ======================================
# Main starts here

#Setup commands
$host = `hostname`; chomp $host;

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "Illegal host name for modality \n" if ($modalityHost eq "");
die "Illegal port number for modality \n" if ($modalityPort eq "");

print `perl scripts/reset_servers.pl`;

announce_start;

announce_106;
produce_106_data($modality, $modalityAE, $modalityStationName);

goodbye;
