#!/usr/local/bin/perl -w

# Runs Image Manager test 102

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
"This is Image Manager test 102 for the subject Brown.\n\n";
}

sub announce_a05_plus {
  print
"\n" .
"The ADT system sends an A05 to the Order Placer and Order Filler \n" .
" to pre-register Brown.\n" .
" We will order and schedule procedure P1 for Brown.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_PPS_X11 {
  print
"\n" .
"At the modality, we decide to perform P11/X11 rather than P1/X1.\n" .
"The MESA Modality will send MPPS messages to you at $mppsAE:$mppsHost:$mppsPort.\n" .
" You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P11_data {
  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD ";
  $x .= " 583030 P11 T102 MESA localhost $mesaOFPortDICOM X1_A1 X11 MR/MR4/MR4S1";

  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not get MWL or produce images.\n";
    goodbye;
  }

  imgmgr::update_scheduling_message(
		"../../msgs/sched/102/102.106.o01.hl7",
		"$MESA_STORAGE/modality/T102/mpps.crt");
}

sub send_MPPS_X11 {
  mesa::send_mpps("T102", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T102", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
}

sub announce_CStore_X11 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P11/X11\n" .
  " to you at $imCStoreAE:$imCStoreHost:$imCStorePort\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub update_X21_identifiers {
# Change Accession Number (OBR-18)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil accnum`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.124.o01.hl7 OBR 18 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.128.o01.hl7 OBR 18 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Accession Number in scheduling message \n";
    exit 1;
  }

# Change Requested Procedure ID (OBR-19)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil req_proc_id`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.124.o01.hl7 OBR 19 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Requested Procedure ID in scheduling message \n";
    exit 1;
  }
  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.128.o01.hl7 OBR 19 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Requested Procedure ID in scheduling message \n";
    exit 1;
  }

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$MESA_TARGET/bin/of_identifier ordfil sps_id`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.124.o01.hl7 OBR 20 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Scheduled Procedure Step ID in scheduling message \n";
    exit 1;
  }
  $x = "perl scripts/change_hl7_field.pl ../../msgs/sched/102/102.128.o01.hl7 OBR 20 $xxx";
  print "$x\n";
  print `$x`;
  if ($?) {
    print "Unable to change Scheduled Procedure Step ID in scheduling message \n";
    exit 1;
  }
}

sub announce_P21 {
  print
"\n" .
"We will now order, schedule (and then cancel P21).  You will receive the\n" .
" the scheduling message first.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P21_cancel {
  print
"\n" .
"We will now cancel P21 and send your Image Mgr a cancel message.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print "\n" .
  "The event section of Image Manager test 102 is complete.  To evaluate \n" .
  " your responses:  \n" .
  "   perl 102/eval_102.pl <AE Title of MPPS Mgr> [-v] \n";
}

# =================================================
# Main starts here

print "Test 102 is obsolete. Please do not use this test.\n";
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
print "Illegal MESA Modality Port: $mesaModPortDICOM \n" if ($mesaModPortDICOM == 0);
print "Illegal C-Find parameters: $imCFindHost $imCFindPort $imCFindAE \n" if ($imCFindPort == 0);
print "Illegal Storage Commit parameters: $imCommitHost $imCommitPort $imCommitAE \n" if ($imCFindPort == 0);

print `perl scripts/reset_servers.pl`;

announce_test;
announce_a05_plus;

$x = mesa::send_hl7("../../msgs/adt/102", "102.102.a05.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("102.102.a05.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/102", "102.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("102.104.o01.hl7") if ($x != 0);

mesa::local_scheduling_mr();

produce_P11_data;

$x = mesa::send_hl7("../../msgs/sched/102", "102.106.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("102.106.o01.hl7") if ($x != 0);

announce_PPS_X11;
send_MPPS_X11;

announce_CStore_X11;
mesa::store_images("T102", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T102", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 1);

mesa::announce_cfind("BROWN",
		$imCFindAE, $imCFindHost, $imCFindPort);

imgmgr::build_cfind("102/102.121.txt", "102/102.121.dcm");
mesa::send_cfind("102/102.121.dcm", 
		$imCFindAE, $imCFindHost, $imCFindPort, "102/cfind/102.121");

update_X21_identifiers;
announce_P21;

$x = mesa::send_hl7("../../msgs/sched/102", "102.124.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("102.124.o01.hl7") if ($x != 0);

announce_P21_cancel;
$x = mesa::send_hl7("../../msgs/sched/102", "102.128.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("102.128.o01.hl7") if ($x != 0);

mesa::announce_a03("BROWN", $imHL7Host, $imHL7Port);

$x = mesa::send_hl7("../../msgs/adt/102", "102.136.a03.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("102.136.a03.hl7") if ($x != 0);
$x = mesa::send_hl7("../../msgs/adt/102", "102.138.a03.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("102.138.a03.hl7") if ($x != 0);

announce_end;

goodbye;
