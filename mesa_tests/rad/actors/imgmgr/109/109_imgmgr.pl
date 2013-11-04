#!/usr/local/bin/perl -w

# Runs Image Manager test 109 interactively.

use Env;
use lib "scripts";
require imgmgr;

# Setup debug and verbose modes
# (debug mode is selected over verbose if both are present)
#$debug = grep /^-.*d/, @ARGV;
#$verbose = grep /^-.*v/, @ARGV  if not $debug;
#$grade = 1;


$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit 0;
}

sub announce_test {
  print "\n" .
"This is Image Manager test 109.  It covers Exception Management in SWF.\n" .
" The patient is GREY^FRANK.\n\n";
}

sub produce_P1_data {

  print "About to produce MPPS, Images and Storage Commit data for P1\n";

  $x = "perl scripts/produce_abandoned_step.pl MR MESA_MOD " .
	" 583080 P1 T109 MESA localhost $mesaOFPortDICOM  X1_A1 X1 MR/MR4/MR4S1 110514";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not get MWL or produce P1 data.\n";
    goodbye;
  }

  $mpps = "$MESA_STORAGE/modality/T109/mpps.crt";
  $uid = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mpps`;
  chomp $uid;
  print `perl scripts/change_scheduling_uid.pl ../../msgs/sched/109/109.106.o01.hl7 $uid`;
  print "Study Instance UID: $uid \n";

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 008 0050 $mpps`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/109/109.106.o01.hl7 OBR 18 $xxx`;
  if ($? != 0) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $mpps`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/109/109.106.o01.hl7 OBR 19 $xxx`;
  if ($? != 0) {
    print "Unable to change  Requested Procedure ID in scheduling message \n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mpps`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/109/109.106.o01.hl7 OBR 20 $xxx`;
  if ($? != 0) {
    print "Unable to change  Requested Procedure ID in scheduling message \n";
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
  mesa::send_mpps("T109", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T109", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
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

sub announce_StorageCommit_X1 {
  print "\n" .
  "The MESA Modality will send a  Storage Commit request for Procedure P1\n" .
  " to you at $imCommitHost:$imCommitPort:$imCommitAE.\n" .
  " When you send your N-Event reports, the MESA modality is found \n" .
  " at port $mesaModPortDICOM on host $host\n\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
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

sub announce_CFind_grey {
  print "\n" .
  "The MESA Image Display will now send C-Find commands for the patient GREY\n" .
  " This query will cover SOP Instances for an abandoned procedure step \n" .
  " that was abandoned because the wrong MWL entry was selected. \n" .
  " That means your Image Manager should return 0 responses. \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_grey {
  open CFIND_TEXT, ">109/cfind_grey.txt" or die "Could not create C-Find query file 109/cfind_grey.txt";

  my $mpps = "$MESA_STORAGE/modality/T109/mpps.status";
  my $studyUID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mpps`;
  my $seriesUID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0340 00020 000E $mpps`;

  print CFIND_TEXT "0008 0052 IMAGE\n";
  print CFIND_TEXT "0008 0016 #\n";
  print CFIND_TEXT "0008 0018 #\n";
  print CFIND_TEXT "0020 000D $studyUID\n";
  print CFIND_TEXT "0020 000E $seriesUID\n";
  close CFIND_TEXT;

  $x = "$MESA_TARGET/bin/dcm_create_object -i 109/cfind_grey.txt 109/cfind_grey.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient GREY \n";
    exit 1;
  }

  $outDir = "109/cfind_grey";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("109/cfind_grey.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "109/cfind_grey");
  if ($x != 0) {
    print "Unable to send C-Find command for patient GREY \n";
    exit 1;
  }

  $outDir = "109/cfind_grey_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("109/cfind_grey.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "109/cfind_grey_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient GREY to MESA server \n";
    exit 1;
  }
}

sub announce_end
{
  print "\n" .
  "The event section of Image Manager test 109 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 109/eval_109.pl <AE Title of MPPS Mgr> <AE Title of Storage Commit SCP> [-v] \n";
}


# =====================================
# Main starts here

$host = `hostname`; chomp $host;

die "Usage: perl 109/109_imgmgr.pl <log level> \n" if (scalar(@ARGV) != 1);
$logLevel = $ARGV[0];

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

mesa::announce_a04("GREY^FRANK", $imHL7Host, $imHL7Port, "N");
mesa::announce_order("GREY:P1", $imHL7Host, $imHL7Port, "N");
mesa::announce_sched("GREY:X1", $imHL7Host, $imHL7Port, "Y");

$x = mesa::send_hl7("../../msgs/adt/109", "109.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("109.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/109", "109.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("109.104.o01.hl7") if ($x != 0);

mesa::local_scheduling_mr($logLevel, "EASTMR", "MODALITY1");

produce_P1_data;
$x = mesa::send_hl7("../../msgs/sched/109", "109.106.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("109.106.o01.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/sched/109", "109.106.o01.hl7", "localhost", $mesaImgMgrPortHL7);
mesa::xmit_error("109.106.o01.hl7") if ($x != 0);

announce_PPS_X1;
send_MPPS_X1;

announce_CStore_X1;
mesa::store_images("T109", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T109", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

#
announce_CFind_grey;
send_CFind_grey;

announce_end;

goodbye;
