#!/usr/local/bin/perl -w

# Runs the Image Manager exam interactively.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
 "This is MESA Image Manager test 1412.  It tests post processing\n" .
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
  print "$x";
  print `$x`;
  print "About to produce P102 images\n";

  $x = "perl scripts/produce_scheduled_images.pl CT MESA_MOD 901412 P102 " .
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

sub send_Images_Available_X102 {
  $outDir = "1412/ia_x1_pre";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "1412/ia_x1_pre_mesa";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

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

sub send_Images_Available_X102_post {
  $outDir = "1412/ia_x1_post";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "1412/ia_x1_post_mesa";
  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P102/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

sub announce_schedule_postprocessing_X102_3DRECON {
  print "\n" .
  "Please schedule post-processing proc step: X102_3DRECON\n" .
"station names: CT_3DRECON1\n" .
"station class: CT_3DRECON\n" .
"station locations: East\n" .
"start date/time: 20021010^1300\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gpsps_CFIND {
  my $procedureName = shift(@_);

  print "\n" .
"The MESA 3D RECON station will send a C-Find to query for its worklist.\n" .
" The current workitem code is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_CFIND_X102_3DRECON {
  if ($MESA_OS eq "WINDOWS_NT") {
    $resultsDir = "1412\\gpsps_x102";
    $resultsDirMESA = "1412\\gpsps_x102_mesa";
  } else {
    $resultsDir = "1412/gpsps_x102";
    $resultsDirMESA = "1412/gpsps_x102_mesa";
  }

  mesa::delete_directory(1,$resultsDir);
  mesa::delete_directory(1,$resultsDirMESA);

  mesa::create_directory($resultsDir);
  mesa::create_directory($resultsDirMESA);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       " -i ../../msgs/ppm/1412/gpspsquery_delaware.txt" .
#       " ../../msgs/ppm/1412/gpspsquery_delaware.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 -c $test_ppmAE" .
       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm -o $resultsDir" .
       " -x GPWL $test_ppmHost $test_ppmPort";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

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
"The MESA CAD station will send a GPSPS NACTION to claim the scheduled procedure
 step.\n" .
" The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_NACTION_X102_3DRECON {
  my $test_sopuid = shift(@_);
  my $mesa_sopuid = shift(@_);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       "-i ../../msgs/ppm/1412/spsclaim.txt ../../msgs/ppm/1412/spsclaim.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 -c $test_ppmAE" .
       " $test_ppmHost $test_ppmPort GPSPS " .
       " ../../msgs/ppm/1412/spsclaim.dcm $test_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS " .
       " ../../msgs/ppm/1412/spsclaim.dcm $mesa_sopuid";
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
"The MESA CAD station will send a GPPPS NCREATE to create the performed \n" .
"procedure step in progress. You should relay this information to the \n" .
"MESA Order Filler at $host:$port\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gppps_completed {
#  my $procedureName = shift(@_);
  my $host = shift(@_);
  my $port = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPPPS NSET to mark the performed \n" .
"procedure step complete. You should relay this information to the \n" .
"MESA Order Filler at $host:$port\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub read_ppsSOPUID {
  my $fname = shift(@_);

  open FILE, $fname or die "Unable to find PPS SOP UID file: $fname\n";

  $uid = <FILE>;
  return $uid;
}

sub write_modfile {
  my $fname = shift(@_);
  my $gpsps_sopinsuid = shift(@_);

  open MODFILE, ">$fname" or die "Unable to open ppscreate modfile: $fname\n";

  print MODFILE
  "0040 4016 (\n" .
  " 0008 1115 $gpsps_sopinsuid\n" .
  ")\n";
}

sub modify_referenced_gpsps {
  my $in_dcmfile = shift(@_);
  my $gpsps_sopinsuid = shift(@_);
  my $out_dcmfile = shift(@_);

  if( $MESA_OS eq "WINDOWS_NT") {
     $modstring = "0040 4016 ( 0008 1155 $gpsps_sopinsuid)";
  }
  else {
     $modstring = "0040 4016 \\( 0008 1155 $gpsps_sopinsuid\\)";
  }

  $x = "echo $modstring > " .
     "$MESA_TARGET/bin/dcm_modify_object  $in_dcmfile $out_dcmfile";

  print "$x\n";
  print `$x`;
}

sub send_gppps_create {
  my $test_gpsps_sopuid = shift(@_);
  my $mesa_gpsps_sopuid = shift(@_);

#  $x = "$MESA_TARGET/bin/dcm_create_object " .
#       " -i ../../msgs/ppm/1412/ppscreate.txt" .
#       " ../../msgs/ppm/1412/ppscreate.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/ppm_sched_gppps -s $mesa_gpsps_sopuid " .
       " -t ../../msgs/ppm/1412/ppscreate.dcm" .
       " -o ../../msgs/ppm/1412/ppscreate.dcm" .
       " -i 1412/gppps_sopuid.txt imgmgr ordfil";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $gppps_sopuid = imgmgr::getSOPUID("../../msgs/ppm/1412/ppscreate.dcm");

  $x = "$MESA_TARGET/bin/ncreate -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort gppps" .
       " ../../msgs/ppm/1412/ppscreate.dcm $gppps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  if( $test_ppmHost ne "localhost") {

     modify_referenced_gpsps( "../../msgs/ppm/1412/ppscreate.dcm", 
              $test_gpsps_sopuid,
              "../../msgs/ppm/1412/test_ppscreate.dcm");

     $x = "$MESA_TARGET/bin/ncreate -a CT_3DRECON1 -c $test_ppmAE" .
         " $test_ppmHost $test_ppmPort gppps" .
         " ../../msgs/ppm/1412/test_ppscreate.dcm" .
         "  $gppps_sopuid";
     if( $MESA_OS eq "WINDOWS_NT") {
        $x =~ s(/)(\\)g;
     }
     print "$x\n";
     print `$x`;
  }
  return $gppps_sopuid;
}

sub send_gppps_completed {
  my $gppps_sopuid = shift(@_);

  #  uses a canned gppps_nset object... 
#  $x = "$MESA_TARGET/bin/dcm_create_object -i ../../msgs/ppm/1412/ppsset.txt" .
#       " ../../msgs/ppm/1412/ppsset.dcm";
#  if( $MESA_OS eq "WINDOWS_NT") {
#     $x =~ s(/)(\\)g;
#  }
#  print "$x\n";
#  print `$x`;

  $x = "$MESA_TARGET/bin/nset -a CT_3DRECON1 -c $test_ppmAE" .
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
  my $procedureName = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPSPS NACTION to mark the scheduled procedure
step complete.\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub send_gpsps_completed {
  my $test_gpsps_sopuid = shift(@_);
  my $mesa_gpsps_sopuid = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object " .
         " -i ../../msgs/ppm/1412/spscomplete.txt" .
         " ../../msgs/ppm/1412/spscomplete.dcm";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 -c $test_ppmAE" .
       " $test_ppmHost $test_ppmPort GPSPS" .
       " ../../msgs/ppm/1412/spscomplete.dcm $test_gpsps_sopuid";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
   print "$x\n";
   print `$x`;

  $x = "$MESA_TARGET/bin/naction -a CT_3DRECON1 " .
       " $mesa_ppmHost $mesa_ppmPort GPSPS" .
       " ../../msgs/ppm/1412/spscomplete.dcm $mesa_gpsps_sopuid";
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
    $resultsDir = "1412\\gpsps_x102_2";
  } else {
    $resultsDir = "1412/gpsps_x102_2";
  }

  mesa::delete_directory(1,$resultsDir);

  mesa::create_directory(1,$resultsDir);

  $x = "$MESA_TARGET/bin/cfind -a MODALITY1 -c $test_ppmAE" .
       " -f ../../msgs/ppm/1412/gpspsquery_delaware.dcm" .
       " -o $resultsDir -x GPWL " .
       " $test_ppmHost $test_ppmPort";
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
  " PPWF Image Manager test.\n" ;
}

sub announce_end {
  print "\n" .
  "The event section of Image Manager test 1412 is complete.  To evaluate \n" .
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
) = imgmgr::read_config_params("imgmgr_test.cfg");

( $mesa_ppmHost, $mesa_ppmPort, $mesa_ppmAE,
  $test_ppmHost, $test_ppmPort, $test_ppmAE,
) = imgmgr::read_ppm_config_params("imgmgr_test.cfg");

die "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

$x = "perl scripts/reset_servers.pl";
if( $MESA_OS eq "WINDOWS_NT") {
   $x =~ s(/)(\\)g;
}
print `$x`;

announce_test;

announce_a04_P1;

#  MESA ADT will send an A04 to the MESA Order Placer to register Delaware.
#  This is unneccessary. OrdPlacer is not even running for this test.

# $x = mesa::send_hl7("../../msgs/adt/1412", "1412.102.a04.hl7", 
#           "localhost", $mesaOFPortHL7);
# mesa::xmit_error("1412.102.a04.hl7") if ($x != 0);


#  MESA ADT will send an A04 to the MESA Order Filler to register Delaware.

$x = mesa::send_hl7("../../msgs/adt/1412", "1412.104.a04.hl7", 
        "localhost", $mesaOFPortHL7);
mesa::xmit_error("1412.104.a04.hl7") if ($x != 0);


#  "MESA Order Placer sends ORM^O01 to MESA Order Filler (Delaware:P102).\n" .

$x = mesa::send_hl7("../../msgs/order/1412", "1412.106.o01.hl7", 
        "localhost", $mesaOFPortHL7);
mesa::xmit_error("1412.106.o01.hl7") if ($x != 0);


#  MESA Modality will query for MWL, create images and PPS, create ORM message.
#  MESA Order Filler will schedule procedure.

produce_P102_data;


#  "MESA Order Filler sends scheduling ORM (Delaware:X102) to test imgmgr\n" .

$x = mesa::send_hl7("../../msgs/sched/1412", "1412.108.o01.hl7", 
        $imHL7Host, $imHL7Port);
mesa::xmit_error("1412.108.o01.hl7") if ($x != 0);


announce_PPS_X102;
#  MESA_MOD sends mpps
mesa::send_mpps("P102", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
mesa::send_mpps("P102", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);


# announce_ImagesAvailable_pre;
# send_Images_Available_X102;

announce_CStore_X102;

mesa::store_images("P102", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("P102", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

announce_StorageCommit_X102;
mesa::send_storage_commit ("P102", $imCommitAE, $imCommitHost, $imCommitPort, $mesaModPortDICOM);

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

send_CFIND_X102_3DRECON;

$mesa_spsSOPUID = imgmgr::getSOPUID("1412/gpsps_x102_mesa/msg1_result.dcm");
chomp $mesa_spsSOPUID;
print "mesa_spsSOPUID: " . $mesa_spsSOPUID . "\n";

$test_spsSOPUID = imgmgr::getSOPUID("1412/gpsps_x102/msg1_result.dcm");
chomp $test_spsSOPUID;
print "test_spsSOPUID: " . $test_spsSOPUID . "\n";

announce_gpsps_claim("X102_3DRECON");

send_NACTION_X102_3DRECON($test_spsSOPUID, $mesa_spsSOPUID);

announce_gppps_create( $host, $mesaOFPortDICOM);

# $ppsSOPUID = read_ppsSOPUID( "1412/pps_sopuid.txt");
# print "ppsSOPUID: " . $ppsSOPUID . "\n";

# this creates the gppps on the MESA PPM (imgmgr)
$gppps_sopuid = send_gppps_create($test_spsSOPUID, $mesa_spsSOPUID);

print "gppps_sopuid: $gppps_sopuid \n";

# forward PPS create to passive PPM here?

announce_gppps_completed( $host, $mesaOFPortDICOM);

send_gppps_completed($gppps_sopuid);

announce_gpsps_completed();

send_gpsps_completed($test_spsSOPUID, $mesa_spsSOPUID);

query_for_gpsps_complete ;

announce_skip;

announce_end;

goodbye;
