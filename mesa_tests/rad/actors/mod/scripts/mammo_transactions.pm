#!/usr/local/bin/perl -w

# This module contains the functions for handling transactions
# in the context of the Evidence Creator actor.

use Env;

package mammo_transactions;
require Exporter;
@ISA = qw(Exporter);

sub processTransaction8 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $modAE) = @_;
  $inputDir = $main::MESA_STORAGE . "/" . $inputDir;

  print "IHE Transaction 8: \n";
#  print "You are expected to send \"For Processing\" image(s) to MESA Image Manager.\n" ;
  print "The parameters for the MESA Image Manager are: $main::mesaImgMgrHost $main::mesaImgMgrPort\n";
  print "Hit <ENTER> when ready (q to quit) --> ";

  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  my $rtnValue = 0;
  if ($selfTest == 1) {
#  my ($logLevel, $deltaFile, $directoryName, $sourceAE, $destAE, $destHost, $destPort, $noPixelsFlag) = @_;

  my $status = mesa_xmit::sendCStoreDirectory(
                $logLevel, "", $inputDir, $modAE,
                $main::mesaImgMgrAE, "localhost",
                $main::mesaImgMgrPort, 0);

  print "mammo_transactions::processTransaction8 DICOM C-Store failed\n" if ($status != 0);
  return $status; 
  #if ($selfTest == 1) {
  #  $rtnValue = mesa::store_images_absolute_path($inputDir, "", $modAE, $main::mesaImgMgrAE, "localhost", $main::mesaImgMgrPort, 0);
  #  mesa::xmit_error($msg) if ($rtnValue != 0);
  #  return $rtnValue;
  }
  return $rtnValue;
}

sub printText {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $txtFile = "../common/" . $tokens[1];
  $inputDir = $main::MESA_STORAGE . "/" . $inputDir;
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
