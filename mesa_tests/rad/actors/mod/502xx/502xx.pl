#!/usr/local/bin/perl -w

# Creates MWL and comparison data for Modality 502xx tests.

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
"This is the setup script for Modality 502xx series tests. \n" .
" This script creates MWL entries and comparison data. \n" .
" It is a one-time script (but won't be harmed if you run it again).\n";
}

sub announce_50201 {
  print "\n" .
  "Producing data for 50201 test (unscheduled).\n\n";
}

sub produce_50201_data {
  my ($mod, $modAE, $stationName) = @_;

  $x = "perl scripts/produce_unscheduled_images.pl $mod $modAE " .
	" 50201 EYE-200 T50201 XEYE_200 OP/OP1/OP1S1 KINGSTON_FRED";

  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 50201 data.\n" if ($?);

  $D = "$MESA_STORAGE/modality/T50201";

  $x = "$MESA_TARGET/bin/dcm_modify_object -t -T -i 50201/50201.del " .
        " $D/x1.dcm 50201/x1.dcm ";
  print "$x \n";
  print `$x`;

  $x = "$MESA_TARGET/bin/dcm_modify_object -i 50201/50201.del " .
        " $D/mpps.crt 50201/mpps.crt";
  print "$x \n";
  print `$x`;


  $x = "$MESA_TARGET/bin/dcm_modify_object -i 50201/50201.del " .
        " $D/mpps.status 50201/mpps.status";
  print "$x \n";
  print `$x`;

  copy ("$D/mpps.set", "50201");
}

sub announce_50202 {
  print "\n" .
  "Producing MWL and data for 50202 test.\n\n";
}

sub produce_50202_data {
  my ($mod, $modAE, $stationName, $protocolCodeFlag) = @_;

  $x = mod::send_hl7("../../msgs/adt/502xx", "50202.110.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("50202.110.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/502xx", "50202.120.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("50202.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 50202 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" 50202 EYE-200 T50202 MESA localhost 2250 EYE_PC_200 XEYE_200 OP/OP1/OP1S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 50202 data.\n" if ($?);
}

sub announce_213 {
  print "\n" .
  "Producing MWL and data for 213 test.\n" .
  " One requested procedure (P8) results in two SPS \n";
}

sub produce_213_data {
  my ($mod, $modAE, $stationName, $protocolCodeFlag) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx", "213.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("213.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "213.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("213.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 213 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM213 P8 T213_8a MESA localhost 2250 X8A_A1 X8A MR/MR5/MR5S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 213 (8A) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM213 P8 T213_8b MESA localhost 2250 X8B_A1 X8B MR/MR5/MR5S1 $protocolCodeFlag";
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
  my ($mod, $modAE, $stationName, $protocolCodeFlag) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx", "214.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("214.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "214.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("214.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 214 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM214 P4 T214_4a MESA localhost 2250 X4A_A1 X4A MR/MR5/MR5S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 214 (4A) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM214 P4 T214_4b MESA localhost 2250 X4B_A1 X4B MR/MR5/MR5S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 214 (4B) data.\n" if ($?);
}

sub announce_50215 {
  print "\n" .
  "Producing MWL and data for 50215 test.\n" .
  " One requested procedure but you will perform a different step instead \n";
}

sub produce_50215_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);


  $x = mod::send_hl7("../../msgs/adt/502xx", "50215.110.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("50215.110.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/502xx", "50215.120.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("50215.120.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 50215 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_different_images.pl $mod $modAE " .
	" 50215 EYE-200 T50215 MESA localhost 2250 EYE_PC_200 XEYE_201 OP/OP1/OP1S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 50215 (XEYE_201) data.\n" if ($?);
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
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "221.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("221.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "221.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("221.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 221 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_group_1rp.pl $mod $modAE " .
	" MM221 T221 MESA localhost 2250 X3A_A1 X3B_A1 X3 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 221 data.\n" if ($?);

#  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
#	" MM221 P3 T221x MESA localhost 2250 X3A_A1 X3 MR/MR4/MR4S1";
#  print "$x \n";
#
#  print `$x`;
#  die "Could not get MWL or produce 221 data.\n" if ($?);
}
sub announce_222 {
  print "\n" .
  "Producing MWL and data for 222 test (Group Case).\n" .
  " Two requested procedure (P6, P7), two SPS, one PPS \n";
}

sub produce_222_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "222.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "222.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.104.o01.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "222.106.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("222.106.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 222 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_group_2rp.pl $mod $modAE " .
	" MM222 T222 MESA localhost 2250 X6_A1 X7_A1 X6-7 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 222 data.\n" if ($?);
}

sub announce_231 {
  print "\n" .
  "Producing MWL and data for 231 test.\n\n";
}

sub produce_231_data {
  my ($mod, $modAE, $stationName, $protocolCodeFlag) = @_;

  $x = mod::send_hl7("../../msgs/adt/2xx", "231.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("231.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "231.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("231.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 231 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM231 P5 T231_orig MESA localhost 2250 X5_A1 X5 MR/MR4/MR4S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 231 (X5_A1) data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" MM231 P5 T231_append MESA localhost 2250 X5_A1 X5 MR/MR4/MR4S1 $protocolCodeFlag";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 231 (X1_A1) data.\n" if ($?);
}

sub announce_241 {
  print "\n" .
  "Producing MWL and data for 241 test.\n\n";
}

sub produce_241_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "241.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("241.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "241.104.o01.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("241.104.o01.hl7") if ($x != 0);

  $x = "$MESA_TARGET/bin/of_schedule -t $modAE -m $mod -s $stationName ordfil";
  print "$x \n";
  print `$x`;
  die "Could not schedule data for test 241 for $modAE:$mod \n" if ($?);

  $x = "perl scripts/produce_abandoned_images.pl $mod $modAE " .
	" MM241 P2 T241 MESA localhost 2250 X2_A1 X2 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce 241 data.\n" if ($?);
}

sub announce_242 {
  print "\n" .
  "Producing MWL and data for 242 test.\n\n";
}

sub produce_242_data {
  my $mod = shift(@_);
  my $modAE = shift(@_);
  my $stationName = shift(@_);

  $x = mod::send_hl7("../../msgs/adt/2xx", "242.102.a04.hl7", "localhost", "$mesa_hl7_port");
  mod::xmit_error("242.102.a04.hl7") if ($x != 0);

  $x = mod::send_hl7("../../msgs/order/2xx", "242.104.o01.hl7", "localhost", "$mesa_hl7_port");
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

my $includePerformedProtocolCode = 1;
$includePerformedProtocolCode = 0 if (scalar(@ARGV) != 0);

#Setup commands
$host = `hostname`; chomp $host;
$mesa_hl7_port = 2200;

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "Illegal host name for modality \n" if ($modalityHost eq "");
die "Illegal port number for modality \n" if ($modalityPort eq "");

$logLevel = 4;
die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa::getMESAVersion();
print "MESA Version: $version\n";

print `perl scripts/reset_servers.pl`;

announce_start;

announce_50201;
produce_50201_data($modality, $modalityAE, $modalityStationName);

announce_50202;
produce_50202_data($modality, $modalityAE, $modalityStationName, $includePerformedProtocolCode);

#announce_213;
#produce_213_data($modality, $modalityAE, $modalityStationName, $includePerformedProtocolCode);
#
#announce_214;
#produce_214_data($modality, $modalityAE, $modalityStationName, $includePerformedProtocolCode);
#

announce_50215;
produce_50215_data($modality, $modalityAE, $modalityStationName);

#announce_218;
#produce_218_data($modality, $modalityAE, $modalityStationName);
#
#announce_221;
#produce_221_data($modality, $modalityAE, $modalityStationName);
#
#announce_222;
#produce_222_data($modality, $modalityAE, $modalityStationName);
#
#announce_231;
#produce_231_data($modality, $modalityAE, $modalityStationName, $includePerformedProtocolCode);
#
#announce_241;
#produce_241_data($modality, $modalityAE, $modalityStationName);
#
#announce_242;
#produce_242_data($modality, $modalityAE, $modalityStationName);
#
#announce_271;
#produce_271_data($modality, $modalityAE, $modalityStationName);

goodbye;
