#!/usr/local/bin/perl -w

# This module contains the functions for handling transactions
# in the context of the Evidence Creator actor.

use Env;

package imgmgr_transactions;
require Exporter;
@ISA = qw(Exporter);

sub processTransaction8 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  print "IHE Transaction 8: \n";
  print "MESA will send DICOM Composite Objects from dir ($inputDir) for event ($event) to $dst \n";

  if ($dst eq "EC") {
    print "imgmgr_transactions::processTransaction8 skip sending data to MESA EC\n";
    return 0;
  }

  if ($dst ne "IM") {
    print "imgmgr_transactions::processTransaction8 destination is expected to be IM (only)\n";
    return 1;
  }
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);
  return 1 if ($x =~ /^Q/);

  $inputDir = $main::MESA_STORAGE . "/" . $inputDir;

  my $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		$main::imCStoreAE, $main::imCStoreHost,
		$main::imCStorePort, 0);

  if ($status != 0) {
   print "imgmgr_transactions::processTransaction8 DICOM C-Store failed to your Image Manager\n";
   return $status;
  }

  $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		"MESA_IMG_MGR", "localhost",
		$main::mesaImgMgrPortDICOM, 0);

  if ($status != 0) {
   print "imgmgr_transactions::processTransaction8 DICOM C-Store failed to MESA Image Manager\n";
   return $status;
  }
  return 0;
}

sub processTransaction10 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleNEventSCU) = @_;

  return processTransaction10NAction($logLevel, $selfTest, $src, $dst, $event,
	$inputDir, $aeTitleNEventSCU) if ($src eq "EC" && $dst eq "IM");
  return processTransaction10NEvent ($logLevel, $selfTest, $src, $dst, $event,
	$inputDir, $aeTitleNEventSCU) if ($src eq "IM" && $dst eq "EC");
  print "evd_transactions::processTransaction10: Unsupported combination of source and destination: $src, $dst\n";
  return 1;
}


sub processTransaction10NAction {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleNEventSCU) = @_;
  print "$src $dst $event\n";

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 10: \n";
  print " MESA Evidence Creator will send N-Action request for \n";
  print " Storage Commitment to IM\n";
  print "IM parameters are ($main::imCommitAE: $main::imCommitHost: $main::imCommitPort)\n";
  print "MESA AE Title: $aeTitleNEventSCU\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  my $NActionFile = "$main::MESA_STORAGE/$inputDir/naction.dcm";

  # Send N-Event report to MESA Image Manager
  if ($selfTest == 0) {
    $status = mesa_xmit::sendStorageCommitNAction(
		$logLevel, $NActionFile,
		$aeTitleNEventSCU,
		"MESA-IM-SC",
		"localhost",
		$main::mesaImgMgrPortDICOM);
    return $status if ($status != 0);
  }

  # Send N-Event report to system under test
  $status = mesa_xmit::sendStorageCommitNAction(
		$logLevel, $NActionFile,
		$aeTitleNEventSCU,
		$main::imCommitAE,
		$main::imCommitHost,
		$main::imCommitPort);

  return $status;
}

sub processTransaction10NEvent {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleNEventSCU) = @_;
  print "$src $dst $event\n";

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 10: \n";
  print " Your Image Manager should send N-Event Report to MESA workstation\n";
  print " MESA parameters are ($aeTitleNEventSCU: $hostname: $main::mesaWkstationPort)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);


  # In the code below, send N-Event reports from MESA back to MESA.
  my ($y, @scFiles) = mesa_get::getOpenSCRequests($logLevel, $aeTitleNEventSCU);
  if ($y != 0) {
    print "imgmgr_transactions::processTransaction10NEvent error searching for open Storage Commit requests\n";
    return 1;
  }
  if (scalar(@scFiles) == 0) {
    print "imgmgr_transactions::processTransaction10NEvent found 0 open Storage Commit requests\n";
    return 1;
  }

  foreach $f(@scFiles) {
    print "imgmgr_transactions::processTransaction10NEvent $f\n" if ($logLevel >= 3);
    $x = "$main::MESA_TARGET/bin/im_sc_agent -a MESA -c $main::mesaWkstationAE localhost $main::mesaWkstationPort $f";
    print "$x\n" if ($logLevel >= 3);
    print `$x`;
    if ($?) {
      print "imgmgr_transactions::processTransaction10NEvent SC error\n";
      return 1;
    }
  }

  return 0;
}

sub processTransaction14 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputParam, $inDir, $outDir, $scuAE) = @_;
# inputParam varies according to the event.
#  QUERY:
#	it is the name of the directory used to store images relative to
#	$MESA_STORAGE/modality
#  QUERY-NAME-HL7
#	is the name of file relative to message directory
#  QUERY-INSTANCE_SOP-CLASS
#	this is a query at the instance level by SOP Class UID
#  QUERY-STUDY_UID
#	query at the Study level by Study Instance UID

  print "IHE Transaction 14: \n";
  print "MESA will send CFIND message ($outDir) for event $event to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

# Clean out and create the output directory
  mesa_utility::delete_directory($logLevel, $outDir);
  mesa_utility::create_directory($logLevel, $outDir);

  ($x, $cfindFile) = mesa_dicom::constructCFindQuery($logLevel, $event,
		$inputParam, $inDir, $outDir);
  return 1 if ($x != 0);

  $x = mesa_xmit::sendCFind($logLevel, "STUDY",
	$cfindFile,
	$main::imCFindAE, $main::imCFindHost, $main::imCFindPort,
	$scuAE, "$outDir/test");

  if ($x != 0) {
    print "imgmgr_transactions::processTransaction14 could not send CFind to IM under test\n";
    return 1;
  }

  $x = mesa_xmit::sendCFind($logLevel, "STUDY",
	$cfindFile,
	"MESA_IM_AE", "localhost", $main::mesaImgMgrPortDICOM,
	$scuAE, "$outDir/mesa");

  if ($x != 0) {
    print "imgmgr_transactions::processTransaction14 could not send CFind to MESA IM \n";
    print " This is a configuration or runtime error\n";
    return 1;
  }

  return 0;
}

sub processTransaction57 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  if ($dst ne "IM") {
    print "evd_transactions::processTransaction57 destination is expected to be IM (only)\n";
    return 1;
  }

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 57: \n";
  print "Evidence creator is expected to send BSPS object to MESA IM\n";
  print "MESA IM parameters are ($main::mesaIMAECStore : $hostname : $main::mesaIMPortDICOM )\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  return 0 if ($selfTest == 0);

  # If we are in self test mode, then send the BSPS object to ourself.
  $inputDir = $main::MESA_STORAGE . "/" . $inputDir;

  $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		$main::mesaIMAECStore, $hostname,
		$main::mesaIMPortDICOM, 0);

  print "evdcrt_transactions::processTransaction57 DICOM C-Store failed\n" if ($status != 0);
  return $status;
}

sub processTransaction62 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  print "IHE Transaction 62: \n";
  if ($event eq "STORE-MSG") {
    print "MESA will send one DICOM Composite Object from file ($inputDir) for event ($event) to $dst \n";
  } else {
    print "MESA will send DICOM Composite Objects from dir ($inputDir) for event ($event) to $dst \n";
  }

  if ($dst ne "IM") {
    print "imgmgr_transactions::processTransaction8 destination is expected to be IM (only)\n";
    return 1;
  }
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);
  return 1 if ($x =~ /^Q/);

  my $status = 1;		# Assume failure
  if ($event eq "STORE-MSG") {
    $pathToFile = "../../msgs/$inputDir";
    $status = mesa_xmit::sendCStoreOneObject (
		$logLevel, "", $pathToFile, $aeTitleCStoreSCU,
		$main::imCStoreAE, $main::imCStoreHost,
		$main::imCStorePort, 0);
    if ($status != 0) {
     print "imgmgr_transactions::processTransaction62 DICOM C-Store failed to your Image Manager\n";
     return $status;
    }

    $status = mesa_xmit::sendCStoreOneObject (
		$logLevel, "", $pathToFile, $aeTitleCStoreSCU,
		"MESA_IMG_MGR", "localhost",
		$main::mesaImgMgrPortDICOM, 0);

    if ($status != 0) {
     print "imgmgr_transactions::processTransaction62 DICOM C-Store failed to MESA Image Manager\n";
     return $status;
    }
  } else {
    $inputDir = $main::MESA_STORAGE . "/" . $inputDir;

    $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		$main::imCStoreAE, $main::imCStoreHost,
		$main::imCStorePort, 0);

    if ($status != 0) {
     print "imgmgr_transactions::processTransaction62 DICOM C-Store failed to your Image Manager\n";
     return $status;
    }

    $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		"MESA_IMG_MGR", "localhost",
		$main::mesaImgMgrPortDICOM, 0);

    if ($status != 0) {
     print "imgmgr_transactions::processTransaction62 DICOM C-Store failed to MESA Image Manager\n";
     return $status;
    }
  }
  return 0;
}


sub printText {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $txtFile = "../common/" . $tokens[1];
  open TXT, $txtFile or die "Could not open text file: $txtFile";
  while ($line = <TXT>) {
    print $line;
  }
  close TXT;
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
}

sub printPatient {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $hl7Msg = "../../msgs/" . $tokens[1];
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  print "Patient Name: $patientName \n";
  print "Patient ID:   $pid\n";
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
}

1;
