#!/usr/local/bin/perl -w

# Runs the Image Manager exam interactively.

use Env;
use lib "scripts";
require imgcrt;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
 "This is MESA Image Creator test 1412.  It tests post processing\n" .
 " transactions for patient DELAWARE.\n" .
 " A CT exam and 3D reconstruction of the data set are scheduled \n" .
 " and performed.\n\n" ;
}

sub announce_a04_P1 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register Delaware.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (Delaware:P1).\n" .
  "MESA Order Filler will schedule procedure.\n" .
  "MESA Modality will query for worklist and produce data.\n" .
  "MESA Order Filler sends scheduling ORM (Delaware:X1) to your\n" .
  " image manager($imHL7Host:$imHL7Port) \n\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
}

sub produce_P102_data {
print "About to schedule\n";

#  MESA_MOD 
  $x = "$MESA_TARGET/bin/of_schedule -t MESA_MOD -m CT -s STATION1 ordfil \n";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x \n";
  print `$x`;
  print "About to produce P102 images\n";

  $x = "perl scripts/produce_scheduled_images.pl CT MESA_MOD 901412 P102 " .
           " P102 MESA localhost $mesaOFPortDICOM  X102_A1 X102 CT/CT1/CT1S2";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x \n";

  print `$x`;
  if ($?) {
    print "Could not get MWL or produce P102 data.\n";
    goodbye;
  }
  print "About to update images...\n";

  $mpps = "$MESA_STORAGE/modality/P102/mpps.crt";
  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $mpps";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  $uid = `$x`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  $x = "perl scripts/change_scheduling_uid.pl " .
           " ../../msgs/sched/1412/1412.108.o01.hl7 $uid";
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
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/1412/1412.108.o01.hl7 OBR 18 $xxx`;
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
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/1412/1412.108.o01.hl7 OBR 19 $xxx`;
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
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/1412/1412.108.o01.hl7 OBR 20 $xxx`;
  if ($? != 0) {
    print "Unable to change Scheduled Procedure Step ID in scheduling msg\n";
    exit 1;
  }
}


sub announce_PPS_X102 {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
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

# sub send_Images_Available_X102 {
# $outDir = "1412/ia_x1_pre";
#  imgmgr::delete_directory($outDir);
#  imgmgr::create_directory($outDir);
#
#  imgmgr::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
#			$imCFindAE, $imCFindHost, $imCFindPort,
#			$outDir);
#
#  $outDir = "1412/ia_x1_pre_mesa";
#  imgmgr::delete_directory($outDir);
#  imgmgr::create_directory($outDir);
#
#  imgmgr::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
#			"MESA", "localhost", $mesaImgMgrPortDICOM,
#			$outDir);
#}

sub announce_CStore_X102 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P102\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
}

sub announce_StorageCommit_X102 {
  print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P102\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  print "\n";
  goodbye if ($response =~ /^q/);
}

#-sub send_storage_commit {
#-  $naction = "$MESA_TARGET/bin/naction -a MESA_MOD -c $imCommitAE "
#-      . " $imCommitHost $imCommitPort commit ";
#-
#-  $nevent = "$MESA_TARGET/bin/nevent -a MESA localhost $mesaModDCMPort commit ";
#-
#-  foreach $procedure (@_) {
#-    print "$procedure \n";
#-
#-    $nactionExec = "$naction $MESA_STORAGE/modality/$procedure/sc.xxx "
#-	. "1.2.840.10008.1.20.1.1";
#-
#-    print "$nactionExec \n";
#-    print `$nactionExec >> 101/grade_imgmgr.log`;
#-    if ($? != 0) {
#-	print "Could not send N-Action event to your Manager\n";
#-	goodbye;
#-    }
#-
#-    $neventExec = "$nevent $MESA_STORAGE/modality/$procedure/sc.xxx "
#-	. "1.2.840.10008.1.20.1.1";
#-
#-    print `$neventExec >> 101/grade_imgmgr.log`;
#-    if ($? != 0) {
#-	print "Could not send N-Event report to MESA Modality\n";
#-	goodbye;
#-    }
#-  }
#-}

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

#sub send_Images_Available_X102_post {
#  $outDir = "1412/ia_x1_post";
#  imgmgr::delete_directory($outDir);
#  imgmgr::create_directory($outDir);
#
#  imgmgr::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
#			$imCFindAE, $imCFindHost, $imCFindPort,
#			$outDir);
#
#  $outDir = "1412/ia_x1_post_mesa";
#  imgmgr::delete_directory($outDir);
#  imgmgr::create_directory($outDir);
#
#  imgmgr::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
#			"MESA", "localhost", $mesaImgMgrPortDICOM,
#			$outDir);
#}

sub announce_schedule_postprocessing_X102_3DRECON {
  print "\n" .
  "MESA will schedule post-processing proc step: X102_3DRECON\n" .
"for patient DELAWARE on:\n" .
"station names: CT_3DRECON1\n" .
"station class: CT_3DRECON\n" .
"station locations: East\n" .
"start date/time: 20021010^1300\n\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gpsps_CFIND {
  my $procedureName = shift(@_);

  print "\n" .
"You should now send a C-Find to query for the general purpose worklist.\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_CFIND_X102_3DRECON {
  if ($MESA_OS eq "WINDOWS_NT") {
#    $resultsDir = "1412\\gpsps_x102";
    $resultsDirMESA = "1412\\gpsps_x102_mesa";
  } else {
#    $resultsDir = "1412/gpsps_x102";
    $resultsDirMESA = "1412/gpsps_x102_mesa";
  }

#  imgcrt::delete_directory($resultsDir);
  imgcrt::delete_directory($resultsDirMESA);

#  imgcrt::create_directory($resultsDir);
  imgcrt::create_directory($resultsDirMESA);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       " -i ../../msgs/ppm/1412/gpspsquery_delaware.txt" .
#       " ../../msgs/ppm/1412/gpspsquery_delaware.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

#  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
#       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm -o $resultsDir" .
#       " -x GPWL $test_ppmHost $test_ppmPort";
#   if( $MESA_OS eq "WINDOWS_NT") {
#      $x =~ s(/)(\\)g;
#   }
#   print "$x\n";
#   print `$x`;

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm -o $resultsDirMESA" .
       " -x GPWL $mesa_ppmHost $mesa_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub announce_gpsps_claim {
  my $procedureName = shift(@_);

  print "\n" .
"Now send a GPSPS NACTION to claim the scheduled procedure step.\n" .
" The current scheduled workitem is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_NACTION_X102_3DRECON {
  my $sopuid = shift(@_);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       "-i ../../msgs/ppm/1412/spsclaim.txt ../../msgs/ppm/1412/spsclaim.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $test_ppmHost $test_ppmPort GPSPS " .
       " ../../msgs/ppm/1412/spsclaim.dcm $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS " .
       " ../../msgs/ppm/1412/spsclaim.dcm $sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub announce_gppps_create {
#  my $procedureName = shift(@_);
  my $host = shift(@_);
  my $port = shift(@_);

  print "\n" .
  "You should now send a GPPPS NCREATE to the MESA Post Processing Mgr at\n" .
  "$host:$port to create the performed procedure step in progress.\n" .
  "\nPress <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gppps_completed {
#  my $procedureName = shift(@_);
  my $host = shift(@_);
  my $port = shift(@_);

  print "\n" .
  "You should now send a GPPPS NSET to the MESA Post Processing Mgr at\n" .
  "$host:$port to mark the performed procedure step complete.\n" .
  "\nPress <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub read_ppsSOPUID {
  my $fname = shift(@_);

  open FILE, $fname or die "Unable to find PPS SOP UID file: $fname\n";

  $uid = <FILE>;
  return $uid;
}

sub send_gppps_create {
  my $gpsps_sopuid = shift(@_);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       " -i ../../msgs/ppm/1412/ppscreate.txt" .
#       " ../../msgs/ppm/1412/ppscreate.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/ppm_sched_gppps -s $gpsps_sopuid " .
       " -t ../../msgs/ppm/1412/ppscreate.dcm" .
       " -o ../../msgs/ppm/1412/ppscreate.dcm " .
       " -i ../../msgs/ppm/1412/gppps_sopuid.txt imgmgr ordfil";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $gppps_sopuid = imgcrt::getSOPUID("../../msgs/ppm/1412/ppscreate.dcm");

  if( $test_ppmHost ne "localhost") {
     $x = "$MESA_TARGET/bin/ncreate -a CT_3DRECON1 " .
         " $test_ppmHost $test_ppmPort gppps" .
         " ../../msgs/ppm/1412/ppscreate.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
     print "$x\n";
     print `$x`;
  }

  $x = "$MESA_TARGET/bin/ncreate -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort gppps" .
       " ../../msgs/ppm/1412/ppscreate.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub send_gppps_completed {
  my $gppps_sopuid = shift(@_);

  #  uses a canned gppps_nset object... 
#  $x = "$MESA_TARGET/bin/dcm_create_object" .
#         " -i ../../msgs/ppm/1412/ppsset.txt" .
#         " ../../msgs/ppm/1412/ppsset.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/nset -a CT_3DRECON1 " .
       " $test_ppmHost $test_ppmPort gppps" .
       " ../../msgs/ppm/1412/ppsset.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/nset -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort gppps" .
       " ../../msgs/ppm/1412/ppsset.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub announce_gpsps_completed {
  my $host = shift(@_);
  my $port = shift(@_);

  print "\n" .
  "You should now send a GPSPS NACTION to the MESA Post Processing Mgr at\n" .
  "$host:$port to mark the scheduled procedure step complete.\n" .
  "\nPress <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_gpsps_completed {
  my $gpsps_sopuid = shift(@_);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#         " -i ../../msgs/ppm/1412/spscomplete.txt" .
#         " ../../msgs/ppm/1412/spscomplete.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $test_ppmHost $test_ppmPort GPSPS" .
       " ../../msgs/ppm/1412/spscomplete.dcm $gpsps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS" .
       " ../../msgs/ppm/1412/spscomplete.dcm $gpsps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

# This should generate a response named "msg1_result.dcm" in
# the results directory.  This response will be examined for
# GP SPS status "IN PROGRESS"
sub query_for_gpsps_claimed {

  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1412\\gpsps_x102_claimed";
  } else {
    $resultsDir = "1412/gpsps_x102_claimed";
  }

  imgcrt::delete_directory($resultsDir);

  imgcrt::create_directory($resultsDir);

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm" .
       " -o $resultsDir -x GPWL " .
       " $mesa_ppmHost $mesa_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;
}

# This should generate a response named "msg1_result.dcm" in
# the results directory.  This response will be examined for
# GP SPS status "complete"
sub query_for_gpsps_complete {

  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1412\\gpsps_x102_complete";
  } else {
    $resultsDir = "1412/gpsps_x102_complete";
  }

  imgcrt::delete_directory($resultsDir);

  imgcrt::create_directory($resultsDir);

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 " .
       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm" .
       " -o $resultsDir -x GPWL " .
       " $mesa_ppmHost $mesa_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

}

sub announce_skip {
  print "\n" .
  "There are other parts of the 1412 case that are included to test\n" .
  " other actors and other features.  We skip those pieces for this \n" .
  " PPWF Image Creator test.\n" ;
}

sub announce_end {
  print "\n" .
  "The event section of Image Creator test 1412 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 1412/eval_1412.pl [-v] \n";
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
) = imgcrt::read_config_params("imgcrt_test.cfg");

( $mesa_ppmHost, $mesa_ppmPort, $mesa_ppmAE,
  $test_ppmHost, $test_ppmPort, $test_ppmAE,
) = imgcrt::read_ppm_config_params("imgcrt_test.cfg");

die "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

$x =  "perl scripts/reset_servers_ppm.pl";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print `$x`;

announce_test;

announce_a04_P1;

#  MESA ADT will send an A04 to the MESA Order Placer to register Delaware.
#  This is unneccessary. OrdPlacer is not even running for this test.

# $x = imgmgr::send_hl7("../../msgs/adt/1412", "1412.102.a04.hl7", 
#           "localhost", $mesaOFPortHL7);
# imgmgr::xmit_error("1412.102.a04.hl7") if ($x != 0);


#  MESA ADT will send an A04 to the MESA Order Filler to register Delaware.

$x = imgcrt::send_hl7("../../msgs/adt/1412", "1412.104.a04.hl7", 
        "localhost", $mesaOFPortHL7);
imgmgr::xmit_error("1412.104.a04.hl7") if ($x != 0);


#  "MESA Order Placer sends ORM^O01 to MESA Order Filler (Delaware:P102).\n" .

$x = imgcrt::send_hl7("../../msgs/order/1412", "1412.106.o01.hl7", 
        "localhost", $mesaOFPortHL7);
imgcrt::xmit_error("1412.106.o01.hl7") if ($x != 0);


#  MESA Modality will query for MWL, create images and PPS, create ORM message.
#  MESA Order Filler will schedule procedure.

produce_P102_data;


#  "MESA Order Filler sends scheduling ORM (Delaware:X102) to test imgmgr\n" .

#$x = imgcrt::send_hl7("../../msgs/sched/1412", "1412.108.o01.hl7", 
#        $imHL7Host, $imHL7Port);
#imgcrt::xmit_error("1412.108.o01.hl7") if ($x != 0);


announce_PPS_X102;
#  MESA_MOD sends mpps
#imgcrt::send_mpps("P102", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
imgcrt::send_mpps("P102", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);


# announce_ImagesAvailable_pre;
# send_Images_Available_X102;

announce_CStore_X102;

# imgcrt::store_images("P102", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
imgcrt::store_images("P102", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 0);

announce_StorageCommit_X102;
imgcrt::send_storage_commit ("P102", $imCommitAE, $imCommitHost, $imCommitPort, $mesaModPortDICOM);

# announce_ImagesAvailable_post;
# send_Images_Available_X102_post;

announce_schedule_postprocessing_X102_3DRECON ;

# create sps for post-proc procedure.

$plaOrdNum  = "A1412Z^MESA_ORDPLC";
$proc  = "X102_3DRECON^ihe^ihe";
$gpspsFile  = "../../msgs/ppm/1412/spscreate.txt";

$x = "$main::MESA_TARGET/bin/ppm_sched_gpsps -o $plaOrdNum -p $proc " .
         " imgmgr $gpspsFile";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print "$x\n";
print `$x`;

announce_gpsps_CFIND("X102_3DRECON");

# query for the created gpsps so we can find SOP Instance UID of GPSPS.
send_CFIND_X102_3DRECON;

$spsSOPUID = imgcrt::getSOPUID("1412/gpsps_x102_mesa/msg1_result.dcm");
chomp $spsSOPUID;
print "spsSOPUID: " . $spsSOPUID . "\n";

announce_gpsps_claim("X102_3DRECON");

# for testing, let MESA IMGCRT claim the workitem.
# send_NACTION_X102_3DRECON($spsSOPUID);

# query for the gpsps again to test if it is claimed. 
query_for_gpsps_claimed ;

announce_gppps_create( $host, $mesa_ppmPort);

# for testing, this creates the gppps on the MESA PPM (imgmgr)
# $pps_sopuid = send_gppps_create($spsSOPUID);
# print "gppps_sopuid: $gppps_sopuid \n";

# forward PPS create to passive PPM here?

announce_gppps_completed( $host, $mesa_ppmPort);

# for testing, this marks the gppps as complete on the MESA PPM (imgmgr)
# send_gppps_completed($gppps_sopuid);

announce_gpsps_completed( $host, $mesa_ppmPort);

# for testing, this marks the gpsps as complete on the MESA PPM (imgmgr)
# send_gpsps_completed($spsSOPUID);

query_for_gpsps_complete ;

announce_skip;

announce_end;

goodbye;
