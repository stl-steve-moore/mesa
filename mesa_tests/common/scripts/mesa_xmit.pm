#!/usr/local/bin/perl -w

# General XMIT package for MESA scripts.

use Env;

package mesa_xmit;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);


sub send_hl7 {
  my ($logLevel, $msg, $target, $port, $version)  = @_;
  die "mesa_xmit::send_hl7_log no version variable specified" if (! $version);

  if (! -e $msg) {
    die "Message $msg does not exist; exiting. \n";
  }

  my $d = "ihe";
  $d = "ihe-iti" if ($version eq "2.4");
  $d = "ihe-iti" if ($version eq "2.5");

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d $d ";

  $x = "$send_hl7 -l $logLevel ";
  $x .= "-c " if ($logLevel) >= 3;
  $x .= " $target $port $msg";
  print "$x\n" if ($logLevel >= 3);
  print `$x`;

  return 1 if $?;

  return 0;
}

sub send_MPPS_in_progress
{
  my ($logLevel, $directoryName, $sourceAE, $destAE, $destHost, $destPort) = @_;

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "mesa_xmit::send_MPPS_in_progress Cound not send MPPS N-Create $directoryName $sourceAE $destAE $destHost $destPort";
    return 1;
  }
  return 0;
}

sub send_MPPS_complete
{
  my ($logLevel, $directoryName, $sourceAE, $destAE, $destHost, $destPort) = @_;

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/nset -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "mesa_xmit::send_MPPS_complete Cound not send MPPS N-Set $directoryName $sourceAE $destAE $destHost $destPort";
    return 1;
  }
  return 0;
}

sub sendCStoreDirectory {
  my ($logLevel, $deltaFile, $directoryName, $sourceAE, $destAE, $destHost, $destPort, $noPixelsFlag) = @_;

  die "mesa_xmit::sendCStoreDirectory no value defined for noPixelsFlag" if not defined ($noPixelsFlag);

  my $cmd = "$main::MESA_TARGET/bin/cstore -q -a $sourceAE -c $destAE";
  $cmd .= " -d $deltaFile" if ($deltaFile ne "");
  $cmd .= " -p" if ($noPixelsFlag == 1);
  $cmd .= " $destHost $destPort $directoryName";

  print "$cmd\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print `$cmd`;
  } else {
    `$cmd`;
  }

  return 1 if ($?);
  return 0;
}

sub sendCStoreDCM {
  my ($logLevel, $deltaFile, $imageDir, $sourceAE, $destAE, $destHost, $destPort, $noPixelsFlag) = @_;

  die "mesa_xmit::sendCStoreDirectory no value defined for noPixelsFlag" if not defined ($noPixelsFlag);

  my $cmd = "$main::MESA_TARGET/bin/cstore -l $logLevel -a $sourceAE -c $destAE";
  $cmd .= " -d $deltaFile" if ($deltaFile ne "");
  $cmd .= " -p" if ($noPixelsFlag == 1);
  $cmd .= " $destHost $destPort ";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
    $imageDir =~ s(\/)(\\)g;
  }

  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
  @imageMsgs = readdir IMAGE;
  closedir IMAGE;

  foreach $imageFile (@imageMsgs) {
    #print "$imageFile\n";
    if ($imageFile =~ /.dcm/) {
      my $cstoreExec = "$cmd $imageDir/$imageFile";
      print "$cstoreExec \n" if($logLevel >=3);
      print `$cstoreExec`;
      if ($? != 0) {
        print "Could not send image $imageFile to Image Manager: $destAE\n";
        print "Exiting...\n";
        exit 1;
      }
    }
  }
  
  return 0;
}

sub sendCStoreOneObject {
  my ($logLevel, $deltaFile, $pathToFile, $sourceAE, $destAE, $destHost, $destPort, $noPixelsFlag) = @_;

  die "mesa_xmit::sendCStoreOneObject no value defined for noPixelsFlag" if not defined ($noPixelsFlag);

  my $cmd = "$main::MESA_TARGET/bin/cstore -l $logLevel -a $sourceAE -c $destAE";
  $cmd .= " -d $deltaFile" if ($deltaFile ne "");
  $cmd .= " -p" if ($noPixelsFlag == 1);
  $cmd .= " $destHost $destPort ";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
    $imageDir =~ s(\/)(\\)g;
  }

  my $cstoreExec = "$cmd $pathToFile";
  print "$cstoreExec \n" if($logLevel >=3);
  print `$cstoreExec`;
  if ($? != 0) {
    print "Could not send object $pathToFile to Image Manager: $destAE\n";
    print "Exiting...\n";
    exit 1;
  }
  
  return 0;
}

sub sendStorageCommitNAction {
  my ($logLevel, $nactionFile, $scuAETitle, $scpAETitle, $destHost, $destPort) = @_;
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $naction = "$main::MESA_TARGET/bin/naction -a $scuAETitle -c $scpAETitle $destHost $destPort commit ";

  $nactionExec = "$naction $nactionFile $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "mesa_xmit::sendStorageCommitNAction Could not send Storage Commitment N-Action to Image Mgr \n";
    return 1;
  }
  return 0;
}

sub sendStorageCommitNEvent {
  my ($logLevel, $nEventFile, $srcAETitle, $dstAETitle, $destHost, $destPort) = @_;
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $nEvent = "$main::MESA_TARGET/bin/nevent  -a $srcAETitle -c $srcAETitle $destHost $destPort commit ";

  $nEventExec = "$nEvent $nEventFile $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "mesa_xmit::sendStorageCommitNEvent Could not send Storage Commitment N-Event to Storage Commitment SCU\n";
    return 1;
  }
  return 0;
}


sub send_cfind_mwl {
  my ($logLevel, $cfindFile, $mwlAE, $mwlHost, $mwlPort, $mwlSCUAE, $outDir) = @_;

  print "mesa_xmit::send_cfind_mwl $cfindFile $mwlAE $mwlHost $mwlPort $mwlSCUAE $outDir\n" if ($logLevel >= 4);
  die "mesa_xmit::send_cfind_mwl Wrong number of arguments" if ! $outDir;

  mesa::delete_directory($logLevel, $outDir) and return 1;
  mesa::create_directory($logLevel, $outDir) and return 1;

  my $cfindString = "$main::MESA_TARGET/bin/cfind -a $mwlSCUAE -c $mwlAE " .
      "-f $cfindFile -o $outDir -x MWL $mwlHost $mwlPort ";

  my $rtnValue = 0;
  if ($logLevel >= 3) {
    print "$cfindString \n";
    print `$cfindString`;
    $rtnValue = 1 if ($?);
  } else {
    `$cfindString`;
    $rtnValue = 1 if ($?);
  }

  return $rtnValue;
}

sub sendCFind {
  my ($logLevel, $class, $cfindFile, $scpAE, $scpHost, $scpPort, $scuAE, $outDir) = @_;

  die "mesa_xmit::send_cfind Wrong number of arguments" if ! $outDir;
  print "mesa_xmit::send_cfind $class $cfindFile $scpAE $scpHost $scpPort $scuAE $outDir\n" if ($logLevel >= 4);
  if ($class ne "PATIENT" && $class ne "STUDY" && $class ne "MWL" && $class ne "GPWL") {
    print "mesa_xmit::send_cfind: class variable ($class) should be one of (PATIENT, STUDY, MWL, GPWL)\n";
    return 1;
  }

  mesa::delete_directory($logLevel, $outDir) and return 1;
  mesa::create_directory($logLevel, $outDir) and return 1;

  my $cfindString = "$main::MESA_TARGET/bin/cfind -a $scuAE -c $scpAE " .
      "-f $cfindFile -o $outDir -x $class $scpHost $scpPort ";

  my $rtnValue = 0;
  if ($logLevel >= 3) {
    print "$cfindString \n";
    print `$cfindString`;
    $rtnValue = 1 if ($?);
  } else {
    `$cfindString`;
    $rtnValue = 1 if ($?);
  }

  return $rtnValue;
}


1;

