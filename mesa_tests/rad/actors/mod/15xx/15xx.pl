#!/usr/local/bin/perl -w

# Creates MWL and comparison data for Modality 15xx tests.

use Env;
use File::Copy;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_start {
  print "\n" .
"This is the setup script for Modality 15xx series tests. \n" .
" This script creates MWL entries and comparison data. \n" .
" It is a one-time script (but won't be harmed if you run it again).\n";
}

sub announce_1591 {
  print "\n" .
  "Producing MWL and data for 1591 test.\n\n";
}

sub produce_1591_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "211.102.a04.hl7", "localhost", "2200");
  mod::xmit_error("211.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "211.104.o01.hl7", "localhost", "2200");
  mod::xmit_error("211.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 1591 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images_secure.pl $mod $modAE " .
	" MM211 P1 T1591 MESA localhost 2250 X1_A1 X1 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 1591 data.\n" if ($?);
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

print `perl scripts/reset_servers_secure.pl`;

announce_start;

announce_1591;
produce_1591_data($modality, $modalityAE, $modalityStationName);

goodbye;
