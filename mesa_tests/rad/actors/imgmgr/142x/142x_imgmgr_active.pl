#!/usr/local/bin/perl -w

# Prepares the Image Manager for 142x series of tests.
# Creates the environment the Image Manager needs to test post processing
# workflow.  This script does the scheduled workflow through storage 
# commitment of CT images.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";
  exit 1;
}

sub produce_P102_data {
  print "\nAbout to schedule P102\n";

#  MESA_MOD 
  $x = "$MESA_TARGET/bin/of_schedule -t MESA_MOD -m CT -s STATION1 ordfil \n";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x";
  print `$x`;

  print "\nAbout to produce P102 images\n";

  $x = "perl scripts/produce_scheduled_images.pl CT MESA_MOD 901421 P102 " .
        " P102 MESA localhost $mesaOFPortDICOM  X102_A1 X102 CT/CT1/CT1S1";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x \n";

  print `$x`;
  if ($?) {
    print "Could not get MWL or produce P102 data.\n";
    goodbye;
  }

  print "\nAbout to update images...\n";

  $mpps = "$MESA_STORAGE/modality/P102/mpps.crt";
  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $mpps";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  $uid = `$x`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  $x = "perl scripts/change_scheduling_uid.pl " .
        " ../../msgs/sched/142x/142x.108.o01.hl7 $uid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print `$x`;
  if ($? != 0) {
    print "Unable to change Study Instance UID in scheduling message \n";
    exit 1;
  }

# Change Accession Number (OBR-18)
  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0270 008 0050 $mpps";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  $xxx = `$x`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/142x/142x.108.o01.hl7 OBR 18 $xxx`;
  if ($? != 0) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $mpps";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  $xxx = `$x`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/142x/142x.108.o01.hl7 OBR 19 $xxx`;
  if ($? != 0) {
    print "Unable to change Requested Procedure ID in scheduling message \n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mpps";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  $xxx = `$x`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/142x/142x.108.o01.hl7 OBR 20 $xxx`;
  if ($? != 0) {
    print "Unable to change Scheduled Procedure Step ID in scheduling msg\n";
    exit 1;
  }
}


sub announce_ImagesAvailable_pre {
  print "\n" .
  "The MESA Order Filler will send Images Available (C-Find) queries \n" .
  " to you at $imCFindHost:$imCFindPort:$imCFindAE.\n" .
  " No images have been sent, so responses should be <empty>. \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
}

sub send_Images_Available_X102 {
  $outDir = "1421/ia_x1_pre";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "1421/ia_x1_pre_mesa";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

sub announce_ImagesAvailable_post {
  print "\n" .
  "The MESA Order Filler will send Images Available (C-Find) queries \n" .
  " to you at $imCFindHost:$imCFindPort:$imCFindAE.\n" .
  " Images have been sent, so responses are expected. \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
}

sub send_Images_Available_X102_post {
  $outDir = "1421/ia_x1_post";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "1421/ia_x1_post_mesa";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}


# End of subroutines, beginning of the main code

#Setup commands
$host = `hostname`; chomp $host;


($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port
) = imgmgr::read_config_params("imgmgr_test.cfg");

# ( $mesa_ppmHost, $mesa_ppmPort, $mesa_ppmAE,
#   $test_ppmHost, $test_ppmPort, $test_ppmAE,
# ) = imgmgr::read_ppm_config_params("imgmgr_test.cfg");

die "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

$x = "perl scripts/reset_servers.pl";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print `$x`;

# announce test
print "\n" .
  "This is MESA Image Manager test script 142x.\n" .
  "It prepares the Image Manager for the 142x series of post-processing\n" .
  "workflow tests.  A CT exam for patient DELAWARE is generated and a \n" .
  "3D reconstruction post processing step is scheduled.\n\n" .
  "Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n\n";
  goodbye if ($response =~ /^q/);

#  MESA ADT will send an A04 to the MESA Order Placer to register Delaware.
#  This is unneccessary. OrdPlacer is not even running for this test.

# $x = mesa::send_hl7("../../msgs/adt/142x", "142x.102.a04.hl7", 
#           "localhost", $mesaOFPortHL7);
# mesa::xmit_error("142x.102.a04.hl7") if ($x != 0);


#  MESA ADT will send an A04 to the MESA Order Filler to register Delaware.

print "\n" .
"MESA ADT will send an A04 to the MESA Order Filler to register Delaware.\n";

$x = mesa::send_hl7("../../msgs/adt/142x", "142x.104.a04.hl7", 
        "localhost", $mesaOFPortHL7);
mesa::xmit_error("142x.104.a04.hl7") if ($x != 0);


#  "MESA Order Placer sends ORM^O01 to MESA Order Filler (Delaware:P102).\n" .

print "\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (Delaware:P102).\n";

$x = mesa::send_hl7("../../msgs/order/142x", "142x.106.o01.hl7", 
        "localhost", $mesaOFPortHL7);
mesa::xmit_error("142x.106.o01.hl7") if ($x != 0);


#  MESA Order Filler will schedule procedure.
#  MESA Modality will query for MWL, create images and PPS, create ORM message.

produce_P102_data;

#  "MESA Order Filler sends scheduling ORM (Delaware:X102) to test imgmgr\n" .
print "\n" .
  "MESA Order Filler sends scheduling ORM (Delaware:X1) to your\n" .
  "image manager ($imHL7Host:$imHL7Port) \n\n" .
  "Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);

$x = mesa::send_hl7("../../msgs/sched/142x", "142x.108.o01.hl7", 
        $imHL7Host, $imHL7Port);
mesa::xmit_error("142x.108.o01.hl7") if ($x != 0);

#  MESA_MOD sends mpps
print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " You are expected forward these to the MESA Order Filler at " .
  "$host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
$response = <STDIN>;
print "\n";
goodbye if ($response =~ /^q/);

mesa::send_mpps("P102", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
mesa::send_mpps("P102", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);


# announce_ImagesAvailable_pre;
# send_Images_Available_X102;

# The MESA Modality will send images for Procedure P102 to the 
# test image manager and the mesa image manager.

print "\n" .
  "The MESA Modality will send Images for Procedure P102\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
print "\n";
goodbye if ($response =~ /^q/);

mesa::store_images("P102", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("P102", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P102\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
print "\n";
goodbye if ($response =~ /^q/);

mesa::send_storage_commit ("P102", $imCommitAE, $imCommitHost, $imCommitPort, $mesaModPortDICOM);

# announce_ImagesAvailable_post;
# send_Images_Available_X102_post;

print "\n" .
  "Please schedule post-processing proc step: X102_3DRECON\n" .
  "station names: CT_3DRECON1\n" .
  "station class: CT_3DRECON\n" .
  "station locations: East\n" .
  "start date/time: 20021010^1300\n" .
  "The MESA Image Manager will do the same.\n" .
  " Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

# create sps for post-proc procedure.

$plaOrdNum  = "A1421Z^MESA_ORDPLC";
$proc  = "X102_3DRECON^ihe^ihe";
$gpspsFile  = "../../msgs/ppm/142x/spscreate.txt";

$x = "$main::MESA_TARGET/bin/ppm_sched_gpsps -o $plaOrdNum -p $proc " .
         " imgmgr $gpspsFile";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print "$x\n";
print `$x`;

print "\n" .
  "This completes 142x, setup for 142x series of tests.\n" .
  "Please continue with specific 142x tests, 1421, 1422.\n" .
  "Press <enter> when ready to continue or <q> to quit: ";
$response = <STDIN>;
goodbye if ($response =~ /^q/);

goodbye;
