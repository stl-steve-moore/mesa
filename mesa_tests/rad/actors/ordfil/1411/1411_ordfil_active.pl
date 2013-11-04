#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "scripts";
require ordfil;

# Find hostname of this machine
$host = `hostname`; chomp $host;
# Setup debug and verbose modes
# (debug mode is selected over verbose if both are present)
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;


$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";
  exit;
}

sub clear_MESA {
  $x = "perl scripts/reset_servers.pl";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print `$x`;
}

sub announce_test {
  print "\n" .
"This is test 1411.  It covers the Post Processing Workflow.\n" .
" for a mammography case. \n" .
" The patient is admitted as CONNECTICUT^HARTFORD.\n";
}

sub send_CFIND_P101 {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1411\\mwl_p101";
    $resultsDirMESA = "1411\\mwl_p101_mesa";
  } else {
    $resultsDir = "1411/mwl_p101";
    $resultsDirMESA = "1411/mwl_p101_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery_connecticut.txt " .
        " mwl/mwlquery_connecticut.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

 $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -c $mwlAE " .
       " -f mwl/mwlquery_connecticut.dcm -o $resultsDir $mwlHost $mwlPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/mwlquery -a MODALITY1 -f mwl/mwlquery_connecticut.dcm " .
       "-o $resultsDirMESA localhost 2250";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;
}

sub send_CFIND_X101_MGCAD {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1411\\gpsps_x101";
    $resultsDirMESA = "1411\\gpsps_x101_mesa";
  } else {
    $resultsDir = "1411/gpsps_x101";
    $resultsDirMESA = "1411/gpsps_x101_mesa";
  }

  ordfil::delete_directory($resultsDir);
  ordfil::delete_directory($resultsDirMESA);

  ordfil::create_directory($resultsDir);
  ordfil::create_directory($resultsDirMESA);

  $x = "$MESA_TARGET/bin/dcm_create_object -i 1411/gpspsquery_connecticut.txt" .
         "  1411/gpspsquery_connecticut.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f 1411/gpspsquery_connecticut.dcm -o $resultsDir " .
       " -x GPWL $test_ppmHost $test_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f 1411/gpspsquery_connecticut.dcm -o $resultsDirMESA " .
       " -x GPWL $mesa_ppmHost $mesa_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

# Query again.  This should generate a response named "msg1_result.dcm" in
# the results directory.  This response will be examined for 
# GP SPS status "complete"
sub query_for_gpsps_complete {

  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1411\\gpsps_x101_2";
  } else {
    $resultsDir = "1411/gpsps_x101_2";
  }

  ordfil::delete_directory($resultsDir);

  ordfil::create_directory($resultsDir);

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f 1411/gpspsquery_connecticut.dcm -o $resultsDir -x GPWL " .
       " $test_ppmHost $test_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub send_NACTION_X101_MGCAD {
  my $sps_sopuid = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object -i 1411/spsclaim.txt " .
          " 1411/spsclaim.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a MG_CAD1 " .
       " $test_ppmHost $test_ppmPort GPSPS 1411/spsclaim.dcm $sps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a MG_CAD1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS 1411/spsclaim.dcm $sps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub send_gppps_create {
  my $gpsps_sopuid = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object " .
      " -i 1411/ppscreate.txt 1411/ppscreate.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/ppm_sched_gppps -s $gpsps_sopuid " .
       " -t 1411/ppscreate.dcm -o 1411/ppscreate.dcm " .
       " -i 1411/gppps_sopuid.txt ordfil ordfil";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $gppps_sopuid = ordfil::getSOPUID("1411/ppscreate.dcm");

  if( $test_ppmHost ne "localhost") {
     $x = "$MESA_TARGET/bin/ncreate -a MG_CAD1 " .
         " $test_ppmHost $test_ppmPort gppps 1411/ppscreate.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
     print "$x\n";
     print `$x`;
  }

  $x = "$MESA_TARGET/bin/ncreate -a MG_CAD1 " .
       " $mesa_ppmHost $mesa_ppmPort gppps 1411/ppscreate.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  return $gppps_sopuid;
}

sub forward_gppps_create {
  my $sopuid = shift(@_);
  my $callingtitle = shift(@_);
  my $calledtitle = shift(@_);
  my $host = shift(@_);
  my $port = shift(@_);

# uses same ppscreate message previously created by send_gppps_create.
#  $x = "$MESA_TARGET/bin/dcm_create_object -i 1411/ppscreate.txt 1411/ppscreate. dcm";
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/ncreate -a $callingtitle -c $calledtitle" .
       " $host $port gppps 1411/ppscreate.dcm $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub send_gppps_completed {
  my $gppps_sopuid = shift(@_);

  #  uses a canned gppps_nset object... (one basic text structured report)
  $x = "$MESA_TARGET/bin/dcm_create_object -i 1411/ppsset.txt 1411/ppsset.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/nset -a MG_CAD1 " .
       " $test_ppmHost $test_ppmPort gppps 1411/ppsset.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/nset -a MG_CAD1 " .
       " $mesa_ppmHost $mesa_ppmPort gppps 1411/ppsset.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub send_gpsps_completed {
  my $gpsps_sopuid = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object -i 1411/spscomplete.txt " .
        " 1411/spscomplete.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a MG_CAD1 " .
       " $test_ppmHost $test_ppmPort GPSPS 1411/spscomplete.dcm $gpsps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a MG_CAD1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS 1411/spscomplete.dcm $gpsps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub produce_P101_data {
  $x = "perl scripts/produce_scheduled_images.pl " .
	" MG MODALITY1 901411 P101 P101 $mwlAE $mwlHost $mwlPort X101_A1 " .
        " X101 MG/MG1/MG1S1 ";

  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not produce P101 data.\n";
    goodbye;
  }
}


sub send_MPPS_X101 {
  ordfil::send_mpps("P101", "MODALITY1", $mppsAE, $mppsHost, $mppsPort);
  ordfil::send_mpps("P101", "MODALITY1", $mppsAE, "localhost", $imPortDICOM);
}

sub announce_end {
  print "\n" .
"This marks the end of Order Filler test 1411.\n" .
" To evaluate results: \n" .
"  perl 1411/eval_1411.pl [-v] \n";
}

# =========================================
# Main starts here

print "\n";
print "------------ Starting ORDFIL exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

# Set Machine names and port numbers

($opPort, $ofPortHL7, $ofHostHL7,
 $mwlAE, $mwlHost, $mwlPort,
 $mppsAE, $mppsHost, $mppsPort,
 $imPortHL7, $imPortDICOM, 
 ) = ordfil::read_config_params("ordfil_test.cfg");
 # $ppwfAE, $ppwfHost, $ppwfPort,
 # $ppwfPortDICOM) = ordfil::read_config_params("ordfil_test.cfg");

( $mesa_ppmHost, $mesa_ppmPort, $mesa_ppmAE,
  $test_ppmHost, $test_ppmPort, $test_ppmAE,
) = ordfil::read_ppm_config_params("ordfil_test.cfg");

die "Empty Order Placer Port" if ($opPort eq "");
die "Empty Order Filler MWL AE" if ($mwlAE eq "");
die "Empty Order Filler MWL Host" if ($mwlHost eq "");
die "Empty Order FIller MWL Port" if ($mwlPort eq "");
die "Empty Image Manager HL7 port" if ($imPortHL7 eq "");
die "Empty Image Manager DICOM port" if ($imPortDICOM eq "");
# die "Empty Post Processing Manager DICOM port" if ($ppwfPortDICOM eq "");

clear_MESA;

announce_test;


ordfil::announce_a04("CONNECTICUT^HARTFORD");

$x = ordfil::send_hl7("../../msgs/adt/1411", "1411.102.a04.hl7",
			"localhost", "2200");
ordfil::xmit_error("1411.102.a04.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/adt/1411", "1411.104.a04.hl7",
		 $ofHostHL7, $ofPortHL7);
ordfil::xmit_error("1411.102.a04.hl7") if ($x != 0);


ordfil::announce_order_orm("P101");

$x = ordfil::send_hl7("../../msgs/order/1411", "1411.106.o01.hl7",
			$ofHostHL7, $ofPortHL7);
ordfil::xmit_error("1411.106.o01.hl7") if ($x != 0);

$x = ordfil::send_hl7("../../msgs/order/1411", "1411.106.o01.hl7",
			"localhost", "2200");
ordfil::xmit_error("1411.106.o01.hl7") if ($x != 0);


ordfil::request_procedure(
  "You should now schedule X101 (MG) to fill the request for P101.",
  $host, $imPortHL7);

ordfil::announce_CFIND("P101");

ordfil::local_scheduling_mg();

send_CFIND_P101;

produce_P101_data;

ordfil::announce_PPS (
	"X101",
	$mppsHost, $mppsPort,
	$host, $imPortDICOM);

send_MPPS_X101;

ordfil::announce_CSTORE("P101/X101");

ordfil::send_images("P101");

ordfil::announce_CSTORE_complete("P101/X101");

print "\n" .
  "You should now schedule post-processing proc step: X101_MGCAD \n" .
  "station names: MG_CAD1\n" .
  "station class: MG_CAD\n" .
  "station locations: East\n" .
  "start date/time: 20021010^1300\n" .
  " Press <enter> when ready to continue or <q> to quit: ";
$response = <STDIN>;
goodbye if ($response =~ /^q/);


ordfil::local_scheduling_postprocessing( 
	"A1411Z^MESA_ORDPLC",
	"X101_MGCAD^ihe^ihe",
	"1411/spscreate.txt");

ordfil::announce_gpsps_CFIND("X101_MGCAD");

send_CFIND_X101_MGCAD;

$sps_sopuid = ordfil::getSOPUID("1411/gpsps_x101_mesa/msg1_result.dcm");
chomp $sps_sopuid;

print "sps_sopuid: " . $sps_sopuid . "\n";

ordfil::announce_gpsps_claim("X101_MGCAD");

send_NACTION_X101_MGCAD($sps_sopuid);

ordfil::announce_gppps_create( $host, $imPortDICOM);

$pps_sopuid = send_gppps_create($sps_sopuid);

print "gppps_sopuid: $gppps_sopuid \n";

#forward PPS create to MESA Img Mgr
 $MESA_OF_AE = "MESA_OF";
 $MESA_IMMGR_AE = "MESA_IMMGR";
 $MESA_IMMGR_HOST = "localhost";
 $MESA_IMMGR_PORT = "2350";
 forward_gppps_create($gppps_sopuid, $MESA_OF_AE, $MESA_IMMGR_AE,
          $MESA_IMMGR_HOST, $MESA_IMMGR_PORT);

ordfil::announce_gppps_completed( $host, $imPortDICOM);

send_gppps_completed($gppps_sopuid);

ordfil::announce_gpsps_completed();

send_gpsps_completed($sps_sopuid);

query_for_gpsps_complete ;

announce_end;

goodbye;

