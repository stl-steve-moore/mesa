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

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub announce_test {
  print "\n" .
"This is MESA Image Manager test 101.  It tests transactions for \n" .
" patient WHITE who is seen first as WHITE and later as an \n" .
" unidentified patient. \n";
}

sub announce_a04_P1 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register White.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (White:P1).\n" .
  "MESA Order Filler will schedule procedure.\n" .
  "MESA Modality will query for worklist and produce data.\n" .
  "MESA Order Filler sends scheduling ORM (White:X1) to your\n" .
  " image manager($imHL7Host:$imHL7Port) \n\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P1_data {
print "About to schedule\n";

  print "$MESA_TARGET/bin/of_schedule -t MESA_MOD -m MR -s STATION1 ordfil \n";
  print `$MESA_TARGET/bin/of_schedule -t MESA_MOD -m MR -s STATION1 ordfil `;
  print "About to produce P1 images\n";

  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD 583020 P1 P1 MESA localhost $mesaOFPortDICOM  X1_A1 X1 MR/MR4/MR4S1";
  print "$x \n";

  print `$x`;
  if ($?) {
    print "Could not get MWL or produce P1 data.\n";
    goodbye;
  }
  print "About to update images...\n";

  $mpps = "$MESA_STORAGE/modality/P1/mpps.crt";
  $uid = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $mpps`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  print `perl scripts/change_scheduling_uid.pl ../../msgs/sched/101/101.106.o01.hl7 $uid`;
  if ($? != 0) {
    print "Unable to change Study Instance UID in scheduling message \n";
    exit 1;
  }

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 008 0050 $mpps`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.106.o01.hl7 OBR 18 $xxx`;
  if ($? != 0) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $mpps`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.106.o01.hl7 OBR 19 $xxx`;
  if ($? != 0) {
    print "Unable to change Requested Procedure ID in scheduling message \n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mpps`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.106.o01.hl7 OBR 20 $xxx`;
  if ($? != 0) {
    print "Unable to change Scheduled Procedure Step ID in scheduling msg\n";
    exit 1;
  }
}


sub announce_PPS_X1 {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X1 {
  mesa::send_mpps("P1", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("P1", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);

#  $ncreate = "$MESA_TARGET/bin/ncreate -a MESA_MOD -c $mppsAE -d $deltaFile ";
#  $nset = "$MESA_TARGET/bin/nset -a MESA_MOD -c $mppsAE ";
#
#  $command[0] = "$ncreate $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.crt "
#	    . "1.113654.3.101.1";
#
#  $command[1] = "$ncreate localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.crt "
#	    . "1.113654.3.101.1";
#
#  $command[2] = "$nset $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.set "
#	    . "1.113654.3.101.1";
#
#  $command[3] = "$nset localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.set "
#	    . "1.113654.3.101.1";
#
#  for ($i = 0; $i < 4; $i++) {
#    print "$command[$i] \n";
#    print `$command[$i] `;
#    if ($? != 0) {
#      print "Could not send MPPS event to your MPPS Mgr or MESA server\n";
#      goodbye;
#    }
#  }
}

sub announce_ImagesAvailable_pre {
  print "\n" .
  "The MESA Order Filler will send Images Available (C-Find) queries \n" .
  " to you at $imCFindHost:$imCFindPort:$imCFindAE.\n" .
  " No images have been sent, so responses should be <empty>. \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_Images_Available_X1 {
  $outDir = "101/ia_x1_pre";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P1/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "101/ia_x1_pre_mesa";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P1/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

sub announce_CStore_X1 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P1\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_StorageCommit_X1 {
  print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P1\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
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
  goodbye if ($response =~ /^q/);
}

sub send_Images_Available_X1_post {
  $outDir = "101/ia_x1_post";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P1/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "101/ia_x1_post_mesa";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P1/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

sub announce_a06 {
  print "\n" .
  "The MESA ADT will send an ADT^A06 to the MESA Order Filler to change \n" .
  " White from an outpatient to an inpatient.  The Order Filler will send \n" .
  " and A06 message to your Image Manager at $imHL7Host:$imHL7Port with \n" .
  " the same information.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a03 {
  print "\n" .
  "The MESA ADT will send an ADT^A03 to the MESA Order Filler to discharge\n" .
  " White.  The Order Filler will send an A03 message to your\n" .
  " Image Manager at $imHL7Host:$imHL7Port with the same information.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P2_data {

#MR MESA_MOD T9020 P2 P2 X2 MR/MR4/MR4S1 M

  $x = "perl scripts/produce_unscheduled_images.pl MR MESA_MOD T9020 P2 P2 X2 MR/MR4/MR4S1 SUNDAY_J1";
  print "$x \n";
  print `$x \n`;
  if ($?) {
    print "Could not produce P2 data.\n";
    goodbye;
  }
  $mpps = "$MESA_STORAGE/modality/P2/mpps.crt";
  $uid = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mpps`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  print `perl scripts/change_scheduling_uid.pl ../../msgs/sched/101/101.165.o01.hl7 $uid`;
  if ($? != 0) {
    print "Unable to change Study Instance UID in scheduling message \n";
    exit 1;
  }

  print
"The following values go into the (post) scheduling message, but not the \n " .
" images or MPPS messages.  The scheduling is done after the procedure: \n" .
"    Accession Number \n" .
"    Requested Procedure ID \n" .
"    Scheduled Procedure Step ID \n";

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil accnum`;
  chomp $xxx;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.165.o01.hl7 OBR 18 $xxx`;
  if ($? != 0) {
    print "Unable to change Accession Number in scheduling msg\n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil req_proc_id`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.165.o01.hl7 OBR 19 $xxx`;
  if ($? != 0) {
    print "Unable to change Requested Procedure ID in scheduling msg\n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil sps_id`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.165.o01.hl7 OBR 20 $xxx`;
  if ($? != 0) {
    print "Unable to change Scheduled Procedure Step ID in scheduling msg\n";
    exit 1;
  }
}

sub announce_X2 {
  $doePatientID = "T9020";
  print "\n" .
"We are about to start Unidentified Patient Case 5 with Procedure P2/X2.\n" .
" For this test, we assume the temporary patient ID used at the modality\n" .
" comes from a pre-assigned list maintained by the Order Filler.\n" .
" The temporary ID is $doePatientID. \n" .
" The temporary patient name is SUNDAY^J1.\n" .
" The first part of this Case 5 consists of MPPS messages sent to \n" .
" your Image Manager at $mppsHost:$mppsPort:$mppsAE. \n" .
" You are expected to forward the MPPS events to the MESA Order Filler \n" .
" at $host:$mesaOFPortDICOM. \n" .
" The first step is to create the images, so it may take a few moments.\n" .
" Press <enter> when you are ready to begin ";

  $doePatientID = <STDIN>; chomp $doePatientID;
}

sub send_MPPS_X2 {
  mesa::send_mpps("P2", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("P2", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);

#  $ncreate = "$MESA_TARGET/bin/ncreate -a MESA_MOD -c $mppsAE -d $deltaFile ";
#  $nset = "$MESA_TARGET/bin/nset -a MESA_MOD -c $mppsAE ";
#
#  $command[0] = "$ncreate $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P2/mpps.crt "
#	    . "1.113654.3.101.2";
#
#  $command[1] = "$ncreate localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P2/mpps.crt "
#	    . "1.113654.3.101.2";
#
#  $command[2] = "$nset $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P2/mpps.set "
#	    . "1.113654.3.101.2";
#
#  $command[3] = "$nset localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P2/mpps.set "
#	    . "1.113654.3.101.2";
#
#  for ($i = 0; $i < 4; $i++) {
#    print "$command[$i] \n";
#    print `$command[$i] `;
#    if ($? != 0) {
#      print "Could not send MPPS event to your MPPS Mgr or MESA server\n";
#      goodbye;
#    }
#  }
}

sub announce_CStore_X2 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P2\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_StorageCommit_X2 {
  print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P2\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_Images_Available_X2_post {
  $outDir = "101/ia_x2_post";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P2/mpps.status",
			$imCFindAE, $imCFindHost, $imCFindPort,
			$outDir);

  $outDir = "101/ia_x2_post_mesa";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  mesa::send_image_avail("$MESA_STORAGE/modality/P2/mpps.status",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			$outDir);
}

sub announce_CFind_doe {
  print "\n" .
  "The MESA Image Display with now send a C-Find request for DOE to \n" .
  " to your Image Manager  at $imCFindHost:$imCFindPort:$imCFindAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_doe {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 101/cfind_doe.txt 101/cfind_doe.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient DOE \n";
    exit 1;
  }

  if ($MESA_OS eq "WINDOWS_NT") {
    $outDir = "101\\cfind_doe";
  } else {
    $outDir = "101/cfind_doe";
  }
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("101/cfind_doe.dcm",
			$imCFindAE, $imCFindHost, $imCFindPort, 
			"101/cfind_doe");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE \n";
    exit 1;
  }

  $outDir = "101/cfind_doe_mesa";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("101/cfind_doe.dcm",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			"101/cfind_doe_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE to MESA server \n";
    exit 1;
  }
}

sub announce_a04_a40 {
  print "\n" .
  "The temporary Patient ID for SUNDAY^J1 will now be merged with a \n" .
  " Patient ID from the ADT system.  This is sent to the Order Filler and \n" .
  " then forwarded to your Image Manager at $imHL7Host:$imHL7Port.\n" .
  " The new patient name is DOE^J2 and the new ID is 583220.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P2 {
  print "\n" .
  "The procedure P2 is ordered at the Order Filler and the Order Placer \n" .
  " provides an Order Placer number.  The Order Filler will then send an \n" .
  " ORM to your Image Manager with (after the fact) scheduling information.\n" .
  " The ORM is sent to you at $imHL7Host:$imHL7Port.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n" .
  "DOE^J2 is now identified as the patient White.  A merge message is sent\n" .
  " from the MESA ADT to the MESA Order Filler.  The MESA Order Filler will\n" .
  " send a merge message to your Image Manager at $imHL7Host:$imHL7Port.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_white {
  print "\n" .
  "The MESA Image Display will now send C-Find commands for the patient\n" .
  " White to test the merge with DOE^J2.  You will be queried by\n" .
  " patient name (WHITE).\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_white {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 101/cfind_white.txt 101/cfind_white.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient WHITE \n";
    exit 1;
  }

  $outDir = "101/cfind_white";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("101/cfind_white.dcm",
			$imCFindAE, $imCFindHost, $imCFindPort, 
			"101/cfind_white");
  if ($x != 0) {
    print "Unable to send C-Find command for patient WHITE \n";
    exit 1;
  }

  $outDir = "101/cfind_white_mesa";
  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("101/cfind_white.dcm",
			"MESA", "localhost", $mesaImgMgrPortDICOM,
			"101/cfind_white_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient WHITE to MESA server \n";
    exit 1;
  }
}

sub announce_P21 {
  print "\n" .
  "The MESA Order Placer and Order Filler will now order and cancel\n" .
  " procedure P21.  You will receive the scheduling message and then\n" .
  " the cancel message from the MESA Order Filler.\n".
  " Press <enter> when ready for the P21 scheduling message or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P21_cancel {
  print "\n" .
  "The MESA Order Placer and Order Filler will now cancel\n" .
  " procedure P21.\n" .
  " Press <enter> when ready for the P21 cancel message or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub update_P21_scheduling {

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil accnum`;
  chomp $xxx;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.184.o01.hl7 OBR 18 $xxx`;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.190.o01.hl7 OBR 18 $xxx`;
  print "Accession Number: $xxx \n";

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil req_proc_id`;
  chomp $xxx;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.184.o01.hl7 OBR 19 $xxx`;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.190.o01.hl7 OBR 19 $xxx`;
  print "Requested Procedure ID: $xxx \n";

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil sps_id`;
  chomp $xxx;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.184.o01.hl7 OBR 20 $xxx`;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/101/101.190.o01.hl7 OBR 20 $xxx`;
  print "Scheduled Procedure Step ID: $xxx \n";
}

sub announce_skip {
  print "\n" .
  "There are other parts of the 101 case that are included to test\n" .
  " other actors.  We skip those pieces for the Image Manager.\n" ;
}

sub announce_end {
  print "\n" .
  "The event section of Image Manager test 101 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 101/eval_101.pl <AE Title of MPPS Mgr> <AE Title of Storage Commit SCP> [-v] \n";
}

# End of subroutines, beginning of the main code

print "Image Manager test 101 is retired.\n" .
      "Please read test instructions for current tests.\n";
exit 1;

#Setup commands
$host = `hostname`; chomp $host;


($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_test.cfg");

die "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

print `perl scripts/reset_servers.pl`;

announce_test;

announce_a04_P1;

print "alpha";
$x = mesa::send_hl7("../../msgs/adt/101", "101.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.102.a04.hl7") if ($x != 0);

print "beta";
$x = mesa::send_hl7("../../msgs/order/101", "101.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.104.o01.hl7") if ($x != 0);

print "gamma";
produce_P1_data;

print "delta";
$x = mesa::send_hl7("../../msgs/sched/101", "101.106.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.106.o01.hl7") if ($x != 0);

print "epsilon";
announce_PPS_X1;
$deltaFile = "101/pps_a.del";
send_MPPS_X1;

print "phi";
announce_ImagesAvailable_pre;
send_Images_Available_X1;

print "kappa";
announce_CStore_X1;

print "lambda";
mesa::store_images("P1", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("P1", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

print "mu";
announce_StorageCommit_X1;
mesa::send_storage_commit ("P1", $imCommitAE, $imCommitHost, $imCommitPort, $mesaModPortDICOM);

# CFIND below
announce_ImagesAvailable_post;
send_Images_Available_X1_post;

print "pi";
announce_a06;
$x = mesa::send_hl7("../../msgs/adt/101", "101.126.a06.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.126.a06.hl7") if ($x != 0);

print "rho";
$x = mesa::send_hl7("../../msgs/adt/101", "101.126.a06.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.126.a06.hl7") if ($x != 0);

print "theta";
announce_a03;
$x = mesa::send_hl7("../../msgs/adt/101", "101.130.a03.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.130.a03.hl7") if ($x != 0);

print "xi";
$x = mesa::send_hl7("../../msgs/adt/101", "101.130.a03.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.130.a03.hl7") if ($x != 0);

print "zeta";
announce_X2;
produce_P2_data;
$deltaFile = "101/pps_b.del";
send_MPPS_X2;

announce_CStore_X2;
mesa::store_images("P2", "101/p2.del", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("P2", "101/p2.del", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

announce_StorageCommit_X2;
mesa::send_storage_commit ("P2", $imCommitAE, $imCommitHost, $imCommitPort, $mesaModPortDICOM);

announce_ImagesAvailable_post;
send_Images_Available_X2_post;

announce_a04_a40;
$x = mesa::send_hl7("../../msgs/adt/101", "101.160.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.160.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/adt/101", "101.161.a40.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.161.a40.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/101", "101.161.a40.hl7", "localhost", $mesaImgMgrPortHL7);
mesa::xmit_error("101.161.a40.hl7") if ($x != 0);

announce_CFind_doe;
send_CFind_doe;

announce_P2;

# We don't need these for this Img Mgr Test: send_orm_to_placer("101.162.o01.hl7");
# We don't need these for this Img Mgr Test: send_orr      ("101.164.o02.hl7");

$x = mesa::send_hl7("../../msgs/sched/101", "101.165.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.165.o01.hl7") if ($x != 0);

announce_a40;
$x = mesa::send_hl7("../../msgs/adt/101", "101.166.a40.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("101.166.a40.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/adt/101", "101.168.a40.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.168.a40.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/101", "101.168.a40.hl7", "localhost", $mesaImgMgrPortHL7);
mesa::xmit_error("101.168.a40.hl7") if ($x != 0);

announce_CFind_white;
send_CFind_white;

update_P21_scheduling;
announce_P21;
# We don't need this for Img Mgr Test: send_orm      ("101.182.o01.hl7");
$x = mesa::send_hl7("../../msgs/sched/101", "101.184.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.184.o01.hl7") if ($x != 0);

announce_P21_cancel;
# We don't need this for Img Mgr Test: send_orm      ("101.188.o01.hl7");

$x = mesa::send_hl7("../../msgs/sched/101", "101.190.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("101.190.o01.hl7") if ($x != 0);

announce_skip;

announce_end;

goodbye;
