#!/usr/local/bin/perl -w

# Runs Image Manager test 106 interactively.

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
"This is test 106.  It covers Presentation of Grouped Procedures.\n" .
" The patient is admitted as GREEN and has procedures P6 and P7 scheduled.\n" .
" These procedures are performed using PGP. \n\n";
}

sub announce_a04 {
  print "\n" .
  "MESA ADT will send an A04 to the MESA Order Filler to register GREEN.\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (BLUE:P6).\n" .
  "MESA Order Placer sends ORM^O01 to MESA Order Filler (BLUE:P7).\n" .
  "MESA Order Filler sends scheduling ORM (BLUE:X6) to your image manager.\n" .
  "MESA Order Filler sends scheduling ORM (BLUE:X7) to your image manager.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub produce_P6_P7_data {
  print "About to produce MPPS, Images and Storage Commit data for P6/P7 (GREEN) \n";

# This portion produces the data as scheduled.  Helps to have that for
# using the MPPS messages to update the scheduling message.
  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" 583050 P6 T106_sched_x6 MESA localhost $mesaOFPortDICOM X6_A1 X6 " .
	" MR/MR4/MR4S1 \n";
  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce T106 data.\n" if ($?);

  $x = "perl scripts/produce_scheduled_images.pl MR MESA_MOD " .
	" 583050 P7 T106_sched_x7 MESA localhost $mesaOFPortDICOM X7_A1 X7 " .
	" MR/MR4/MR4S1 \n";
  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce T106 data.\n" if ($?);

# Now generate the real data: Grouped Procedure Steps
  $x = "perl scripts/produce_group_2rp.pl MR MESA_MOD 583050 " .
        " T106 MESA localhost $mesaOFPortDICOM X6_A1 X7_A1 X6-7 MR/MR4/MR4S1";

  print "$x \n";
  print `$x`;
  die "Could not get MWL or produce T106 data.\n" if ($?);

  imgmgr::update_scheduling_message(
		"../../msgs/sched/106/106.108.o01.hl7",
		"$MESA_STORAGE/modality/T106_sched_x6/mpps.crt");

  imgmgr::update_scheduling_message(
		"../../msgs/sched/106/106.110.o01.hl7",
		"$MESA_STORAGE/modality/T106_sched_x7/mpps.crt");
}

sub produce_P6_GSPS {
 $x = "perl scripts/produce_scheduled_gsps.pl PR MESA_MOD " .
        " 583050 P6 T106_gsps_x6 MESA localhost $mesaOFPortDICOM X6_A1 X6 " .
        " T106 106/options_x6.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X6) \n" if ($?);

 $x = "$MESA_TARGET/bin/dcm_modify_object -i 106/delta_gsps.txt $MESA_STORAGE/modality/T106_gsps_x6/gsps.dcm $MESA_STORAGE/modality/T106_gsps_x6/gsps_modified.dcm";
  print "$x\n";
  print `$x`;
  die "Could not modify GSPS object with sequence 0070 005A\n" if ($?);

  mesa::rm_files("$MESA_STORAGE/modality/T106_gsps_x6/gsps.dcm");
}

sub produce_P7_GSPS {
 $x = "perl scripts/produce_scheduled_gsps.pl PR MESA_MOD " .
        " 583050 P7 T106_gsps_x7 MESA localhost $mesaOFPortDICOM X7_A1 X7 " .
        " T106 106/options_x7.txt ";

  print "$x\n";
  print `$x`;
  die "Could not get MWL or produce GSPS objects (X7) \n" if ($?);

 $x = "$MESA_TARGET/bin/dcm_modify_object -i 106/delta_gsps.txt $MESA_STORAGE/modality/T106_gsps_x7/gsps.dcm $MESA_STORAGE/modality/T106_gsps_x7/gsps_modified.dcm";
  print "$x\n";
  print `$x`;
  die "Could not modify GSPS object with sequence 0070 005A\n" if ($?);

  mesa::rm_files("$MESA_STORAGE/modality/T106_gsps_x7/gsps.dcm");
}


# $x = "perl scripts/produce_scheduled_gsps.pl PR MESA_MOD " .
#        " 583050 P6 T106_gsps_x6 MESA localhost $mesaOFPortDICOM X6_A1 X6 " .
#        " T106 106/options_x6.txt ";

sub announce_PPS_X6_X7 {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " These messages are for the single set of images, group case, X6, X7 \n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub send_MPPS_X6_X7 {
  mesa::send_mpps("T106", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T106", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
}


sub announce_PPS_gsps {
  print "\n" .
  "The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
  " These messages are for the two sets of GSPS objects.\n" .
  " There will be two sets of MPPS messages, one set for each GSPS object. \n" .
  " You are expected forward these to the MESA Order Filler at $host:$mesaOFPortDICOM \n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}
sub send_MPPS_X6_gsps {
  mesa::send_mpps("T106_gsps_x6", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T106_gsps_x6", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
}

sub send_MPPS_X7_gsps {
  mesa::send_mpps("T106_gsps_x7", "MESA_MOD", $mppsAE, $mppsHost, $mppsPort);
  mesa::send_mpps("T106_gsps_x7", "MESA_MOD", $mppsAE, "localhost", $mesaOFPortDICOM);
}


sub announce_CStore_X6_X7 {
  print "\n" .
  "The MESA Modality will send Images for Procedure P6/P7 (group case)\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_CStore_GSPS {
  print "\n" .
  "The MESA Modality will send GSPS objects for Procedures P6 and P7\n" .
  " to you at $imCStoreHost:$imCStorePort:$imCStoreAE.\n" .
  " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
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

sub announce_end
{
  print "\n" .
  "The event section of Image Manager test 106 is complete. \n" .
  " The MESA tools do not evaluate your reponses. You do need to \n" .
  " display the appropriate images and send screen captures \n" .
  " for evaluation. \n\n";
}

# ==========================
# Main starts here

$host = `hostname`; chomp $host;

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
 $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_test.cfg");

print "Illegal MESA Image Mgr HL7 Port: $mesaImgMgrPortHL7 \n" if ($mesaImgMgrPortHL7 == 0);
print "Illegal Manager C-Find AE: $imCFindAE\n" if ($imCFindAE eq "");
print "Illegal Manager C-Find Port: $imCFindPort\n" if ($imCFindPort == 0);
print "Illegal Manager C-Find Host: $imCFindHost\n" if ($imCFindHost eq "");

print `perl scripts/reset_servers.pl`;

announce_test;

announce_a04;

$x = mesa::send_hl7("../../msgs/adt/106", "106.102.a04.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("106.102.a04.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/106", "106.104.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("106.104.o01.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/order/106", "106.106.o01.hl7", "localhost", $mesaOFPortHL7);
mesa::xmit_error("106.106.o01.hl7") if ($x != 0);

my $logLevel = 1;
mesa::local_scheduling_mr($logLevel, "EASTMR", "MR3T");
#mesa::local_scheduling_mr($logLevel);

produce_P6_P7_data;
produce_P6_GSPS;
produce_P7_GSPS;

$x = mesa::send_hl7("../../msgs/sched/106", "106.108.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("106.108.o01.hl7") if ($x != 0);

$x = mesa::send_hl7("../../msgs/sched/106", "106.110.o01.hl7", $imHL7Host, $imHL7Port);
mesa::xmit_error("106.110.o01.hl7") if ($x != 0);

announce_PPS_X6_X7;
send_MPPS_X6_X7;

announce_PPS_gsps;
send_MPPS_X6_gsps;
send_MPPS_X7_gsps;

announce_CStore_X6_X7;

mesa::store_images("T106", "", "MESA_MOD", $imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T106", "", "MESA_MOD", "MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 0);
announce_CStore_GSPS;
mesa::store_images("T106_gsps_x6", "", "MESA_MOD",
			$imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T106_gsps_x6", "", "MESA_MOD",
			"MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 0);
mesa::store_images("T106_gsps_x7", "", "MESA_MOD",
			$imCStoreAE, $imCStoreHost, $imCStorePort, 0);
mesa::store_images("T106_gsps_x7", "", "MESA_MOD",
			"MESA_IMG_MGR", "localhost", $mesaImgMgrPortDICOM, 0);

announce_end;

goodbye;
