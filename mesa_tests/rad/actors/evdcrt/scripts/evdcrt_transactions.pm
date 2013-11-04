#!/usr/local/bin/perl -w

# This module contains the functions for handling transactions
# in the context of the Evidence Creator actor.

use Env;

package evdcrt_transactions;
require Exporter;
@ISA = qw(Exporter);

sub processTransaction8 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  print "IHE Transaction 8: \n";
  print "MESA will send images from dir ($inputDir) for event ($event) to $dst \n";
  if ($dst ne "EC") {
    print "evd_transactions::processTransaction8 destination is expected to be EC (only)\n";
    return 1;
  }
  print "If your Evidence Creator already has this data, you can skip this step.\n";
  print "Hit <ENTER> when ready (s to skip, q to quit) --> ";
  my $x = <STDIN>;
  return 0 if ($x =~ /^s/);
  return 0 if ($x =~ /^S/);
  return 1 if ($x =~ /^q/);
  return 1 if ($x =~ /^Q/);

  $inputDir = $main::MESA_STORAGE . "/" . $inputDir;

  my $status = mesa_xmit::sendCStoreDirectory(
		$logLevel, "", $inputDir, $aeTitleCStoreSCU,
		$main::testCStoreSCPAE, $main::testCStoreSCPHost,
		$main::testCStoreSCPPort, 0);

  print "evdcrt_transactions::processTransaction8 DICOM C-Store failed\n" if ($status != 0);
  return $status;
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
  print " Evidence creator is expected to send N-Action request for \n";
  print " Storage Commitment to MESA IM\n";
  print "MESA IM parameters are ($main::mesaIMAEStorageCommit: $hostname : $main::mesaIMPortDICOM )\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  return 0 if ($selfTest == 0);
  # In self test mode, send N-Action request to the MESA IM.

  my $NActionFile = "$main::MESA_STORAGE/$inputDir/naction.dcm";

  $status = mesa_xmit::sendStorageCommitNAction(
		$logLevel, $NActionFile,
		$main::testAEStorageCommit,
		$main::mesaIMAEStorageCommit, "localhost",
		$main::mesaIMPortDICOM);

  return $status;
}

sub processTransaction10NEvent {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleNEventSCU) = @_;
  print "$src $dst $event\n";

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 10: \n";
  print "MESA will send N-Event report to Evidence Creator\n";
  print "Evidence Creator parameters are ($main::testAEStorageCommit: $main::testStorageCommitHost : $main::testStorageCommitPort )\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  return 1 if ($x =~ /^q/);

  my ($y, @scFiles) = mesa_get::getOpenSCRequests($logLevel, $main::testAEStorageCommit);
  if ($y != 0) {
    print "evdcrt_transactions::processTransaction10NEvent error searching for open Storage Commit requests\n";
    return 1;
  }
  if (scalar(@scFiles) == 0) {
    print "evdcrt_transactions::processTransaction10NEvent found 0 open Storage Commit requests\n";
    return 1;
  }

  foreach $f(@scFiles) {
    print "evdcrt_transactions::processTransaction10NEvent $f\n" if ($logLevel >= 3);
    $x = "$main::MESA_TARGET/bin/im_sc_agent -a $main::mesaIMAEStorageCommit -c $main::testAEStorageCommit $main::testStorageCommitHost $main::testStorageCommitPort $f";
    print "$x\n" if ($logLevel >= 3);
    print `$x`;
    if ($?) {
      print "evdcrt_transactions::processTransaction10NEvent SC error\n";
      return 1;
    }
  }

  return 0;

#  return 0 if ($selfTest == 0);
#  # In self test mode, send N-Action request to the MESA IM.
#
#  my $NActionFile = "$main::MESA_STORAGE/$inputDir/naction.dcm";
#
#  $status = mesa_xmit::sendStorageCommitNAction(
#		$logLevel, $NActionFile,
#		$main::testAEStorageCommit,
#		$main::mesaIMAEStorageCommit, "localhost",
#		$main::mesaIMPortDICOM);
#
}

sub processTransaction56 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  if ($dst ne "IM") {
    print "evd_transactions::processTransaction56 destination is expected to be IM (only)\n";
    return 1;
  }

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 56 or 57: \n";
  print "Evidence creator is expected to send SPATIAL Reg. or BSPS DCM object to MESA IM\n";
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

  print "evdcrt_transactions::processTransaction56 DICOM C-Store failed\n" if ($status != 0);
  return $status;
}

sub processTransaction57 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $aeTitleCStoreSCU) = @_;

  if ($dst ne "IM") {
    print "evd_transactions::processTransaction57 destination is expected to be IM (only)\n";
    return 1;
  }

  my ($status, $hostname) = mesa_get::getHostName($logLevel);
  return 1 if ($status != 0);

  print "IHE Transaction 56 or 57: \n";
  print "Evidence creator is expected to send SPATIAL Reg. or BSPS DCM object to MESA IM\n";
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
