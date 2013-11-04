#!/usr/local/bin/perl -w

# Creates MWL and comparison data for Modality 2xx tests.

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
"This is the setup script for Modality 2xx series tests. \n" .
" This script creates MWL entries and comparison data. \n" .
" It is a one-time script (but won't be harmed if you run it again).\n";
}

sub announce_201 {
  print "\n" .
  "Producing data for 201 test (unscheduled).\n\n";
}

sub produce_201_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = "perl scripts/produce_unscheduled_images.pl $mod $modAE " .
	" 583020 P1 T201 X1 MR/MR4/MR4S1 WHITE_CHARLES";

  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 201 data.\n" if ($?);

  $D = "$MESA_STORAGE/modality/T201";

  $x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
        " $D/x1.dcm 201/x1.dcm ";
  print "$x \n";
  print `$x`;

  $x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
        " $D/mpps.crt 201/mpps.crt";
  print "$x \n";
  print `$x`;


  $x = "$MESA_TARGET/bin/dcm_modify_object -i 201/201.del " .
        " $D/mpps.status 201/mpps.status";
  print "$x \n";
  print `$x`;

  copy ("$D/mpps.set", "201");
}

sub produce_himss_orders_cr {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/himss-2004", "tumor.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("tumor.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/himss-2004", "tumor.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("tumor.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test tumor for $modAE:$mod \n" if ($?);
}

sub produce_himss_orders_ct {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/order/himss-2004", "tumor.106.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("tumor.106.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test tumor for $modAE:$mod \n" if ($?);
}

# ======================================
# Main starts here

#Setup commands
$host = `hostname`; chomp $host;
$mesa_hl7_port = 2200;

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "Illegal modality \n" if ($modality eq "");
die "Illegal host name for modality \n" if ($modalityHost eq "");
die "Illegal port number for modality \n" if ($modalityPort eq "");

print `perl scripts/reset_servers.pl`;

announce_start;

produce_himss_orders_cr("CR", $modalityAE, $modalityStationName);
produce_himss_orders_ct("CT", $modalityAE, $modalityStationName);

goodbye;
