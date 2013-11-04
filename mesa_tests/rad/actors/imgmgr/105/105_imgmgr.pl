#!/usr/local/bin/perl -w

# Runs Image Manager test 105 interactively.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit 1;
}

sub announce_test {
  print "\n" .
"This is test 105.  It covers the Unscheduled Patient Case 3.\n" .
" The patient is admitted as DOE^J4 for the beginning of the test. \n" .
" The patient is later renamed to MUSTARD. \n" ;
}

sub announce_a04 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register DOE^J4.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P2_data {
  $x = "perl scripts/produce_unscheduled_images.pl " .
        " MR MESA_MOD 583085 P2 T105 X2 MR/MR4/MR4S1 DOE_J4";

  print "$x\n";
  print `$x`;

  print "Could not produce P2 data.\n" if ($?);

  $mpps = "$MESA_STORAGE/modality/T105/mpps.crt";

  $uid = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mpps`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  print `perl scripts/change_scheduling_uid.pl ../../msgs/sched/105/105.118.o01.hl7 $uid`;

  print
"The following values go into the (post) scheduling message, but not the \n " .
" images or MPPS messages.  The scheduling is done after the procedure: \n" .
"    Accession Number \n" .
"    Requested Procedure ID \n" .
"    Scheduled Procedure Step ID \n";

# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil accnum`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/105/105.118.o01.hl7 OBR 18 $xxx`;

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil req_proc_id`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/105/105.118.o01.hl7 OBR 19 $xxx`;

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil sps_id`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl ../../msgs/sched/105/105.118.o01.hl7 OBR 20 $xxx`;
}

sub announce_PPS_X2 {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X2 {
  mesa::send_mpps("T105", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T105", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
}

sub announce_CStore_X2 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P2\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_doe {
  print "\n" .
"The MESA Image Display will now send C-Find commands for the patient\n" .
" DOE^J4.  We should see one study in the response. \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_doe {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 105/cfind_doe.txt 105/cfind_doe.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient DOE \n";
    exit 1;
  }

  $outDir = "105/cfind_doe";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("105/cfind_doe.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "105/cfind_doe");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE \n";
    exit 1;
  }
  $outDir = "105/cfind_doe_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("105/cfind_doe.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "105/cfind_doe_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient DOE to MESA server \n";
    exit 1;
  }
}

sub announce_sched {
  print "\n" .
  "The MESA Order Filler will send the scheduling message for X2 to \n" .
  " your Image Manager at $imHL7Host:$imHL7Port.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_a08 {
  print "\n" .
"MESA ADT will send an A08 to the MESA Order Filler to change the name.\n" .
" to MUSTARD.  This message is also sent to your Image Manager.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CFind_mustard {
  print "\n" .
"The MESA Image Display will now send C-Find commands for the patient\n" .
" MUSTARD.  We should see one study in the response. \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_CFind_mustard {
  $x = "$MESA_TARGET/bin/dcm_create_object -i 105/cfind_mustard.txt 105/cfind_mustard.dcm";
  print "$x \n";
  print `$x`;
  if ($? != 0) {
    print "Unable to create C-Find command for patient MUSTARD \n";
    exit 1;
  }

  $outDir = "105/cfind_mustard";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("105/cfind_mustard.dcm",
                        $imCFindAE, $imCFindHost, $imCFindPort,
                        "105/cfind_mustard");
  if ($x != 0) {
    print "Unable to send C-Find command for patient MUSTARD \n";
    exit 1;
  }
  $outDir = "105/cfind_mustard_mesa";

  mesa::delete_directory(1, $outDir);
  mesa::create_directory(1, $outDir);

  $x = mesa::send_cfind("105/cfind_mustard.dcm",
                        "MESA", "localhost", $mesaImgMgrPortDICOM,
                        "105/cfind_mustard_mesa");
  if ($x != 0) {
    print "Unable to send C-Find command for patient MUSTARD to MESA server \n";
    exit 1;
  }
}

sub announce_end
{
  print "\n" .
  "The event section of Image Manager test 105 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 105/eval_105.pl <AE Title of MPPS Mgr> [-v] \n";
}


# =====================================
# Main starts here

print "This script is now deprecated. Please read the Image Manager test instructions\n";
print " about how to run test 105.\n";
print " To get on-line help: perl scripts/imgmgr_swl.pl \n";
exit 1;

$host = `hostname`; chomp $host;

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_test.cfg");

die "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);
die "Illegal MESA Modality Port: $mesaModPortDICOM \n" if ($mesaModPortDICOM == 0);
die "Illegal Storage Commit Host \n" if ($imCommitHost eq "");
die "Illegal Storage Commit Port \n" if ($imCommitPort eq "");
die "Illegal Storage Commit AE Title\n" if ($imCommitAE eq "");

print `perl scripts/reset_servers.pl`;

announce_test;
announce_a04;
$x = mesa::send_hl7("../../msgs/adt/105", "105.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("105.102.a04.hl7") if ($x != 0);

produce_P2_data;

announce_PPS_X2;
send_MPPS_X2;

announce_CStore_X2;
mesa::store_images("T105", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T105", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

announce_CFind_doe;
send_CFind_doe;

announce_sched;
$x = mesa::send_hl7("../../msgs/sched/105", "105.118.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("105.118.o01.hl7") if ($x != 0);

announce_a08;
$x = mesa::send_hl7("../../msgs/adt/105", "105.120.a08.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("105.120.a08.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/adt/105", "105.122.a08.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("105.122.a08.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/105", "105.122.a08.hl7", "localhost", $mesaImgMgrPortHL7);
mesa::xmit_error("105.122.a08.hl7") if ($x != 0);

announce_CFind_mustard;
send_CFind_mustard;

announce_end;

goodbye;
