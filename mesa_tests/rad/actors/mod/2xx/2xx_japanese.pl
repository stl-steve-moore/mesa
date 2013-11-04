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
	" 583020 P1 T201 X1 MR/MR4/MR4S1 NAME_PATIENT";

  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 201 data.\n" if ($?);

  $D = "$MESA_STORAGE/modality/T201";

  $x = "$MESA_TARGET/bin/dcm_modify_elements " .
        " $D/x1.dcm 201/x1.dcm < 201/201_japanese.del";
  print "$x \n";
  print `$x`;

  $x = "$MESA_TARGET/bin/dcm_modify_elements  " .
        " $D/mpps.crt 201/mpps.crt < 201/201_japanese.del";
  print "$x \n";
  print `$x`;


  $x = "$MESA_TARGET/bin/dcm_modify_elements " .
        " $D/mpps.status 201/mpps.status < 201/201_japanese.del";
  print "$x \n";
  print `$x`;

  copy ("$D/mpps.set", "201");
}

sub announce_211 {
  print "\n" .
  "Producing MWL and data for 211 test.\n\n";
}

sub produce_211_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mesa::send_hl7_log($logLevel, "../../msgs/adt/2xx-j", "211.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("211.102.a04.hl7") if ($x != 0);

  $x = mesa::send_hl7_log($logLevel, "../../msgs/order/2xx-j", "211.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("211.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -c ISO2022JP -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 211 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images-j.pl $mod $modAE " .
	" MM211 P1 T211 MESA localhost 2250 GX.01.00_PC1 GX.01.00 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 211 data.\n" if ($?);
}

sub announce_213 {
  print "\n" .
  "Producing MWL and data for 213 test.\n" .
  " One requested procedure (P8) results in two SPS \n";
}

sub produce_213_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "213.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("213.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "213.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("213.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 213 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM213 P8 T213_8a MESA localhost 2250 X8A_A1 X8A MR/MR5/MR5S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 213 (8A) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM213 P8 T213_8b MESA localhost 2250 X8B_A1 X8B MR/MR5/MR5S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 213 (8B) data.\n" if ($?);
}

sub announce_214 {
  print "\n" .
  "Producing MWL and data for 214 test.\n" .
  " One requested procedure (P4) results in two SPS, 3 Action Items \n";
}

sub produce_214_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "214.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("214.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "214.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("214.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 214 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM214 P4 T214_4a MESA localhost 2250 X4A_A1 X4A MR/MR5/MR5S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 214 (4A) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM214 P4 T214_4b MESA localhost 2250 X4B_A1 X4B MR/MR5/MR5S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 214 (4B) data.\n" if ($?);
}

sub announce_215 {
  print "\n" .
  "Producing MWL and data for 215 test.\n" .
  " One requested procedure (P10) but you will perform X2 instead \n";
}

sub produce_215_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);


  $x = mod::send_hl7("../../msgs/adt/2xx", "215.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("215.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "215.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("215.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 215 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_different_images.pl $mod $modAE " .
	" MM215 P10 T215 MESA localhost 2250 X10_A1 X2 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 215 (X2) data.\n" if ($?);
}

sub announce_218 {
  print "\n" .
  "Producing MWL and data for 218 test.\n" .
  " One requested procedure (P1) results in one SPS, 1 Protocol Code Item \n";
}

sub produce_218_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "218.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("218.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "218.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("218.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 218 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM218 P1 T218 MESA localhost 2250 X1_A1 X1 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 218 (X1) data.\n" if ($?);

  $D = "$MESA_STORAGE/modality/T218";
  $x = "$MESA_TARGET/bin/dcm_modify_object -i 218/218_delta.txt " .
        " $D/mpps.crt 218/mpps.crt";
  print "$x \n";
  print `$x`;


  $x = "$MESA_TARGET/bin/dcm_modify_object -i 218/218_delta.txt " .
        " $D/mpps.status 218/mpps.status";
  print "$x \n";
  print `$x`;

  copy("218/mpps.crt", "$D");
  copy("218/mpps.status", "$D");
  return 0;
}


sub announce_221 {
  print "\n" .
  "Producing MWL and data for 221 test (Group Case).\n" .
  " One requested procedure (P3), two SPS \n";
}

sub produce_221_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "221.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("221.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "221.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("221.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 221 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_group_1rp.pl $mod $modAE " .
	" MM221 T221 MESA localhost 2250 XA.02.00_PC1 XA.02.00_PC2 XA.02.00 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 221 data.\n" if ($?);
}

sub announce_222 {
  print "\n" .
  "Producing MWL and data for 222 test (Group Case).\n" .
  " Two requested procedure (P6, P7), two SPS, one PPS \n";
}

sub produce_222_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "222.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "222.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.104.o01.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "222.106.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.106.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 222 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_group_2rp.pl $mod $modAE " .
	" MM222 T222 MESA localhost 2250 X6_A1 NM.02.00_PC1 X6-NM.02.00 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 222 data.\n" if ($?);
}

sub announce_231 {
  print "\n" .
  "Producing MWL and data for 231 test.\n\n";
}

sub produce_231_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "231.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("231.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "231.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("231.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 231 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM231 P5 T231_x5 MESA localhost 2250 MR.01.00_PC1 MR.01.00 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 231 (X5_A1) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM231 P5 T231_x1 MESA localhost 2250 MR.01.00_PC1 GX.01.00 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 231 (X1_A1) data.\n" if ($?);
}

sub announce_241 {
  print "\n" .
  "Producing MWL and data for 241 test.\n\n";
}

sub produce_241_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "241.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("241.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "241.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("241.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 241 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_abandoned_images.pl $mod $modAE " .
	" MM241 P2 T241 MESA localhost 2250 GX.01.01_PC1 GX.01.01 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 241 data.\n" if ($?);
}

sub announce_242 {
  print "\n" .
  "Producing MWL and data for 242 test.\n\n";
}

sub produce_242_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx-j", "242.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("242.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx-j", "242.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("242.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 242 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_abandoned_images.pl $mod $modAE " .
	" MM242 P1 T242 MESA localhost 2250 X1_A1 X1 MR/MR4/MR4S1 110505";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 242 data.\n" if ($?);
}

sub announce_271 {
  print "\n" .
  "Producing MWL and data for 271 test.\n\n";
}

sub produce_271_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "271.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("271.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "271.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("271.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 271 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM271 P1 T271 MESA localhost 2250 X1_A1 X1 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 271 data.\n" if ($?);
}


# ======================================
# Main starts here

#Setup commands
$host = `hostname`; chomp $host;
$mesa_hl7_port = 2200;
$logLevel = 1;
$logLevel = $ARGV[0] if scalar(@ARGV) > 0;

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "Illegal host name for modality \n" if ($modalityHost eq "");
die "Illegal port number for modality \n" if ($modalityPort eq "");

print `perl scripts/reset_servers.pl`;

announce_start;

announce_201;
produce_201_data($modality, $modalityAE, $modalityStationName);

announce_211;
produce_211_data($modality, $modalityAE, $modalityStationName);

announce_213;
produce_213_data($modality, $modalityAE, $modalityStationName);

#announce_214;
#produce_214_data($modality, $modalityAE, $modalityStationName);
#
#announce_215;
#produce_215_data($modality, $modalityAE, $modalityStationName);
#
#announce_218;
#produce_218_data($modality, $modalityAE, $modalityStationName);
#
announce_221;
produce_221_data($modality, $modalityAE, $modalityStationName);

announce_222;
produce_222_data($modality, $modalityAE, $modalityStationName);

announce_231;
produce_231_data($modality, $modalityAE, $modalityStationName);

announce_241;
produce_241_data($modality, $modalityAE, $modalityStationName);

announce_242;
produce_242_data($modality, $modalityAE, $modalityStationName);

#announce_271;
#produce_271_data($modality, $modalityAE, $modalityStationName);

goodbye;
