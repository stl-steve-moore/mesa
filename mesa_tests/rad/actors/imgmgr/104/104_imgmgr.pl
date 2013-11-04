#!/usr/local/bin/perl -w

# Runs Image Manager test 104 interactively.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit 0;
}

sub announce_test {
  print "\n" .
"This is test 104.  It covers the Unscheduled Patient Case 2.\n" .
" The patient is admitted as BLUE and has a normal encounter.\n" .
" In the second half of the test, we go through Unidentified Case #2.\n\n";
}

sub announce_a04 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register BLUE.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (BLUE:P4).\n" .
  "MESA Order Filler sends scheduling ORM (BLUE:X4) to your image manager.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P4_data {
  print "About to produce MPPS, Images and Storage Commit data for P4 (BLUE) \n";

  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" 583040 P4 T104a MESA localhost $mesaOFPortDICOM X4A_A1 X4A MR/MR5/MR5S1 \n";

  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce P4 data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" 583040 P4 T104b MESA localhost $mesaOFPortDICOM X4B_A1 X4B MR/MR5/MR5S1 \n";

  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce P4 data.\n" if ($?);

  imgmgr::update_scheduling_message(
		"../../msgs/sched/104/104.106.o01.hl7",
		"$MESA_STORAGE/modality/T104a/mpps.crt");

  my $mpps_P4b = "$MESA_STORAGE/modality/T104b/mpps.crt";

# Need to make more changes because this Order has 2 SPS, 3 AI
# Change Scheduled Procedure Step ID (OBR-20)

  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mpps_P4b`;
  chomp $xxx;
  print "Scheduled Procedure Step ID for X4B: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/104/104.106.o01.hl7 OBR 20 $xxx 2`;
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/104/104.106.o01.hl7 OBR 20 $xxx 3`;
}

sub announce_PPS_X4 {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X4 {
  mesa::send_mpps("T104a", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T104a", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
  mesa::send_mpps("T104b", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T104b", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);

#  $ncreate = "$MESA_TARGET/bin/ncreate -a MESA_MOD -c $mppsAE ";
#  $nset = "$MESA_TARGET/bin/nset -a MESA_MOD -c $mppsAE ";
#
#  $command[0] = "$ncreate $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P4a/mpps.crt "
#	    . "1.113654.3.104.1";
#
#  $command[1] = "$ncreate localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P4a/mpps.crt "
#	    . "1.113654.3.104.1";
#
#  $command[2] = "$nset $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P4a/mpps.set "
#	    . "1.113654.3.104.1";
#
#  $command[3] = "$nset localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P4a/mpps.set "
#	    . "1.113654.3.104.1";
#
#  $command[4] = "$ncreate $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P4b/mpps.crt "
#	    . "1.113654.3.104.2";
#
#  $command[5] = "$ncreate localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P4b/mpps.crt "
#	    . "1.113654.3.104.2";
#
#  $command[6] = "$nset $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P4b/mpps.set "
#	    . "1.113654.3.104.2";
#
#  $command[7] = "$nset localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P4b/mpps.set "
#	    . "1.113654.3.104.2";
#
#  for ($i = 0; $i < 8; $i++) {
#    print "$command[$i] \n";
#    print `$command[$i]`;
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

sub send_Images_Available_X4 {

}

sub announce_CStore_X4 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P4\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a04_doe {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register DOE^J3.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (DOE^J3:P1).\n" .
  "MESA Order Filler sends scheduling ORM (DOE^J3:X1) to your image manager.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P1_data {
  print "About to produce MPPS, Images and Storage Commit data for P4 (BLUE) \n";

  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" 583045 P1 T104c MESA localhost $mesaOFPortDICOM X1_A1 X1 MR/MR4/MR4S1 \n";

  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce P1 data.\n" if ($?);

  imgmgr::update_scheduling_message(
		"../../msgs/sched/104/104.148.o01.hl7",
		"$MESA_STORAGE/modality/T104c/mpps.crt");
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
  mesa::send_mpps("T104c", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T104c", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);

#  $ncreate = "$MESA_TARGET/bin/ncreate -a MESA_MOD -c $mppsAE ";
#  $nset = "$MESA_TARGET/bin/nset -a MESA_MOD -c $mppsAE ";
#
#  $command[0] = "$ncreate $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.crt "
#	    . "1.113654.3.104.3";
#
#  $command[1] = "$ncreate localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.crt "
#	    . "1.113654.3.104.3";
#
#  $command[2] = "$nset $mppsHost $mppsPort mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.set "
#	    . "1.113654.3.104.3";
#
#  $command[3] = "$nset localhost $mesaOFPortDICOM mpps "
#	. "$MESA_STORAGE/modality/P1/mpps.set "
#	    . "1.113654.3.104.3";
#
#  for ($i = 0; $i < 4; $i++) {
#    print "$command[$i] \n";
#    print `$command[$i]`;
#    if ($? != 0) {
#      print "Could not send MPPS event to your MPPS Mgr or MESA server\n";
#      goodbye;
#    }
#  }
}

sub send_Images_Available_X1 {

}

sub announce_CStore_X1 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P1\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_StorageCommit_X4 {
  print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P4\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
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

sub send_storage_commit {
  $naction = "$MESA_TARGET/bin/naction -a MESA_MOD -c $imCommitAE "
      . " $imCommitHost $imCommitPort commit ";

  $nevent = "$MESA_TARGET/bin/nevent -a MESA localhost $mesaModPortDICOM commit ";

  foreach $procedure (@_) {
    print "$procedure \n";

    $nactionExec = "$naction $MESA_STORAGE/modality/$procedure/sc.xxx "
	. "1.2.840.10008.1.20.1.1";

    print "$nactionExec \n";
    print `$nactionExec`;
    if ($? != 0) {
	print "Could not send N-Action event to your Manager\n";
	goodbye;
    }

    $neventExec = "$nevent $MESA_STORAGE/modality/$procedure/sc.xxx "
	. "1.2.840.10008.1.20.1.1";

    print `$neventExec`;
    if ($? != 0) {
	print "Could not send N-Event report to MESA Modality\n";
	goodbye;
    }
  }
}

sub announce_ImagesAvailable_post {
  print "\n" .
  "The MESA Order Filler will send Images Available (C-Find) queries \n" .
  " to you at $imCFindHost:$imCFindPort:$imCFindAE.\n" .
  " Images have been sent, so responses are expected. \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a40 {
  print "\n" .
"The ADT system will send an A40 to merge BLUE/DOE^J3.\n\n" .
" You will get a copy from the MESA Order Filler.\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);

}

sub announce_CFind_blue_pre {
  print "\n" .
"The MESA Image Display will now send C-Find commands for the patient\n" .
" BLUE.  We should see one study in the response. \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_doe {
  print "\n" .
"The MESA Image Display will now send C-Find commands for the patient\n" .
" DOE^J3.  We should see one study in the response. \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_blue_post {
  print "\n" .
"The MESA Image Display will now send C-Find commands for the patient\n" .
" BLUE to test the merge with DOE^J3.  We should see two studies in the \n" .
" response. \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_blue_pre {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 104/cfind_blue.txt 104/cfind_blue.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient BLUE \n";
    exit 1;
  }

  $outDir = "104/cfind_blue_pre";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_blue.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "104/cfind_blue_pre");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE \n";
    exit 1;
  }
  $outDir = "104/cfind_blue_pre_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_blue.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "104/cfind_blue_pre_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE to MESA server \n";
    exit 1;
  }
}

sub send_CFind_doe {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 104/cfind_doe.txt 104/cfind_doe.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient BLUE \n";
    exit 1;
  }

  $outDir = "104/cfind_doe";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_doe.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "104/cfind_doe");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE \n";
    exit 1;
  }
  $outDir = "104/cfind_doe_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_doe.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "104/cfind_doe_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE to MESA server \n";
    exit 1;
  }
}

sub send_CFind_blue_post {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 104/cfind_blue.txt 104/cfind_blue.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient BLUE \n";
    exit 1;
  }

  $outDir = "104/cfind_blue_post";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_blue.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "104/cfind_blue_post");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE \n";
    exit 1;
  }
  $outDir = "104/cfind_blue_post_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("104/cfind_blue.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "104/cfind_blue_post_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient BLUE to MESA server \n";
    exit 1;
  }
}

sub announce_end
{
  print "\n" .
  "The event section of Image Manager test 104 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 104/eval_104.pl <AE Title of MPPS Mgr> [-v] \n";
}

# ==========================
# Main starts here

print "Test 104 has been replaced by other tests. Please do not use this test.\n";
exit 1;

$host = `hostname`; chomp $host;

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_test.cfg");

print "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

print `perl scripts/reset_servers.pl`;

announce_test;

announce_a04;

$x = mesa::send_hl7("../../msgs/adt/104", "104.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("104.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/104", "104.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("104.104.o01.hl7") if ($x != 0);

mesa::local_scheduling_mr();

produce_P4_data;

#send_orm_sched("104.106.o01_3sps.hl7");

$x = mesa::send_hl7("../../msgs/sched/104", "104.106.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("104.106.o01.hl7") if ($x != 0);

announce_PPS_X4;
send_MPPS_X4;

#announce_ImagesAvailable_pre;
#send_Images_Available_X4;

announce_CStore_X4;
mesa::store_images("T104a", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T104a", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);
mesa::store_images("T104b", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T104b", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

announce_StorageCommit_X4;
mesa::send_storage_commit ("T104a", $imCommitAE, $imCommitHost, $imCommitPort,
	$mesaModPortDICOM);
mesa::send_storage_commit ("T104b", $imCommitAE, $imCommitHost, $imCommitPort,
	$mesaModPortDICOM);

#announce_ImagesAvailable_post;
#send_Images_Available_X4;


## Now start the round as DOE^J3
announce_a04_doe;

$x = mesa::send_hl7("../../msgs/adt/104", "104.142.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("104.142.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/104", "104.145.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("104.145.o01.hl7") if ($x != 0);

mesa::local_scheduling_mr();

produce_P1_data;

$x = mesa::send_hl7("../../msgs/sched/104", "104.148.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("104.148.o01.hl7") if ($x != 0);

announce_PPS_X1;
send_MPPS_X1;

announce_CStore_X1;
mesa::store_images("T104c", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T104c", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

announce_CFind_blue_pre;
send_CFind_blue_pre;

announce_CFind_doe;
send_CFind_doe;

announce_a40;
$x = mesa::send_hl7("../../msgs/adt/104", "104.182.a40.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("104.182.a40.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/104", "104.184.a40.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("104.184.a40.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/104", "104.184.a40.hl7", "localhost", $mesaImgMgrPortHL7);
mesa::xmit_error("104.184.a40.hl7") if ($x != 0);

announce_CFind_blue_post;
send_CFind_blue_post;

announce_end;

goodbye;
