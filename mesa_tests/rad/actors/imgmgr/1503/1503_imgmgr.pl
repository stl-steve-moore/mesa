#!/usr/local/bin/perl -w

# Runs Image Manager test 1503 interactively.

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
"This is Image Manager test 1503.  It covers the Unidentified Patient case 1\n" .
" The patient DOE^J1 will be registered and later renamed SILVERHEELS.\n\n" .
" This test uses the same messages and sequence as Image Manger test 103.\n" .
" This test adds the Basic Security profile.\n\n";
}

sub announce_a04 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register DOE^J1.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (DOE:P1).\n" .
  "MESA Order Filler sends scheduling ORM (DOE:X1) to your image manager.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P1_data {

  print "About to produce MPPS, Images and Storage Commit data for P1\n";

  $x = "perl scripts/produce_scheduled_images_secure.pl MR MESA_MOD " .
	" 583295 P1 T1503 MESA localhost $mesaOFPortDICOM  X1_A1 X1 MR/MR4/MR4S1 ";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not get MWL or produce P1 data.\n";
    goodbye;
  }

  $mpps = "$MESA_STORAGE/modality/T1503/mpps.crt";
  $uid = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mpps`;
  chomp $uid;
  print `perl scripts/change_scheduling_uid.pl ../../msgs/sched/103/103.106.o01.hl7 $uid`;
  print "Study Instance UID: $uid \n";

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 008 0050 $mpps`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/103/103.106.o01.hl7 OBR 18 $xxx`;
  if ($? != 0) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $mpps`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/103/103.106.o01.hl7 OBR 19 $xxx`;
  if ($? != 0) {
    print "Unable to change  Requested Procedure ID in scheduling message \n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mpps`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/103/103.106.o01.hl7 OBR 20 $xxx`;
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
  mesa::send_mpps_secure("T1503", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

  mesa::send_mpps_secure("T1503", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
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

sub announce_a08 {
  print "\n" .
"The MESA ADT will now send an A08 to the MESA Order Filler to change the\n" .
" patient name to SILVERHEELS (and to fill in other demographics).  The\n" .
" Order Filler will forward that message to your Image Manager\n" .
" at $imHL7Host:$imHL7Port with the same informattion.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_doe {
  print "\n" .
  "The MESA Image Display will now send C-Find commands for the patient DOE\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_doe {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 103/cfind_doe.txt 103/cfind_doe.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient DOE \n";
    exit 1;
  }

  $outDir = "1503/cfind_doe";

  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  $x = imgmgr::send_cfind_secure("103/cfind_doe.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "1503/cfind_doe",
			"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE \n";
    exit 1;
  }

  $outDir = "1503/cfind_doe_mesa";

  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  $x = imgmgr::send_cfind_secure("103/cfind_doe.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "1503/cfind_doe_mesa",
			"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE to MESA server \n";
    exit 1;
  }
}

sub announce_CFind_silverheels {
  print "\n" .
  "The MESA Image Display will now send C-Find commands for the patient\n" .
  " SILVERHEELS to test the merge with DOE^J1.  You will be queried by\n" .
  " patient name (SILVERHEELS).\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_silverheels {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 103/cfind_silverheels.txt 103/cfind_silverheels.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient SILVERHEELS \n";
    exit 1;
  }

  $outDir = "1503/cfind_silverheels";

  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  $x = imgmgr::send_cfind_secure("103/cfind_silverheels.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "1503/cfind_silverheels",
			"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  if ($x != 0) {
    print "Unable to send C-Find command for patient SILVERHEELS \n";
    exit 1;
  }

  $outDir = "1503/cfind_silverheels_mesa";

  mesa::delete_directory(1,$outDir);
  mesa::create_directory(1,$outDir);

  $x = imgmgr::send_cfind_secure("103/cfind_silverheels.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "1503/cfind_silverheels_mesa",
			"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
  if ($x != 0) {
    print "Unable to send C-Find command for patient SILVERHEELS to MESA server \n";
    exit 1;
  }
}

sub announce_end
{
  print "\n" .
  "The event section of Image Manager test 1503 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 1503/eval_1503.pl <AE Title of MPPS Mgr> <AE Title of Storage Commit SCP> [-v] \n";
}


# =====================================
# Main starts here

print "Image Manager test 1503 is retired. Please do not use this test.\n";
exit 1;

$host = `hostname`; chomp $host;

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_secure.cfg");

print "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);

print `perl scripts/reset_servers_secure.pl`;

announce_test;

announce_a04;

$x = mesa::send_hl7("../../msgs/adt/103", "103.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("103.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/103", "103.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("103.104.o01.hl7") if ($x != 0);

mesa::local_scheduling_mr();

produce_P1_data;
#send_orm_sched("103.106.o01.hl7");
$x = mesa::send_hl7_secure("../../msgs/sched/103", "103.106.o01.hl7", $imHL7Host, $imHL7Port,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
mesa::xmit_error("103.106.o01.hl7") if ($x != 0);

$x = mesa::send_hl7_secure("../../msgs/sched/103", "103.106.o01.hl7", "localhost", $mesaImgMgrPortHL7,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
mesa::xmit_error("103.106.o01.hl7") if ($x != 0);

announce_PPS_X1;
send_MPPS_X1;

announce_CStore_X1;
mesa::store_images_secure("T1503", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
mesa::store_images_secure("T1503", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

#
announce_StorageCommit_X1;
imgmgr::send_storage_commit_secure ("T1503", $imCommitAE, $imCommitHost, $imCommitPort,
	$mesaModPortDICOM,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");

#announce_ImagesAvailable_post;
#send_Images_Available_X1;

announce_CFind_doe;
send_CFind_doe;

announce_a08;
#send_adt      ("103.130.a08.hl7");

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.132.a08.hl7", $imHL7Host, $imHL7Port,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
mesa::xmit_error("103.132.a08.hl7") if ($x != 0);

$x = mesa::send_hl7_secure("../../msgs/adt/103", "103.132.a08.hl7", "localhost", $mesaImgMgrPortHL7,
	"randoms.dat", "mesa_1.key.pem", "mesa_1.cert.pem", "test_list.cert", "NULL-SHA");
mesa::xmit_error("103.132.a08.hl7") if ($x != 0);

announce_CFind_silverheels;
send_CFind_silverheels;

announce_end;

goodbye;
