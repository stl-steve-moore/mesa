#!/usr/local/bin/perl -w

# Supp ortpackage for MESA DICOM evaluation.

use Env;

package mesa_evaluate;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);


sub findMPPSDirByPatientID {
  my ($logLevel, $directoryName, $pid, $mppsMessageType) = @_;

  if (! $mppsMessageType) {
    print "ERR: Programming Error, no variable set in findMPPSDirByPatientID for mppsMessageType\n";
    print "ERR: Please log a MESA bug report\n";
    exit 1;
  }

  print main::LOG "CTX: mesa_dicom_eval_support::findMPPSDirByPatientID $pid $directoryName\n" if ($logLevel >= 3);

  my @rtnMPPS;
  if (! -e $directoryName) {
    print "ERR: The directory $directoryName does not exist. \n" .
          "ERR: Are you using the proper AE title for MPPS ? \n";
    print main::LOG "ERR: The directory $directoryName does not exist. \n" .
          "ERR: Are you using the proper AE title for MPPS ? \n";
    return @rtnMPPS;
  }

  opendir MPPS, $directoryName  or die "directory: $directoryName not found!";
  @mppsDirectories = readdir MPPS;
  closedir MPPS;

  my $mppsIDX = 0;

  ENTRY: foreach $d (@mppsDirectories) {
    next ENTRY if ($d eq ".");
    next ENTRY if ($d eq "..");

    $f = "$directoryName/$d/$mppsMessageType.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if ($logLevel >= 3);
    next ENTRY if (! (-e $f));

    $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    print main::LOG " $f <$id> \n" if ($logLevel >= 3);

    if ($pid eq $id) {
      $rtnMPPS[$mppsIDX] = "$directoryName/$d";
      $mppsIDX++;
    }
  }

#  return @mpps;
  return @rtnMPPS
}

sub findMPPSDirByStudyInstanceUID {
  my ($logLevel, $directoryName, $uid, $mppsMessageType) = @_;

  if (! $mppsMessageType) {
    print "ERR: Programming Error, no variable set in findMPPSDirByStudyInstanceUID for mppsMessageType\n";
    print "ERR: Please log a MESA bug report\n";
    exit 1;
  }

  print main::LOG "CTX: mesa_dicom_eval_support::findMPPSDirByStudyInstanceUID $uid $directoryName\n" if ($logLevel >= 3);

  my @rtnMPPS;
  if (! -e $directoryName) {
    print "ERR: The directory $directoryName does not exist. \n" .
          "ERR: Are you using the proper AE title for MPPS ? \n";
    print main::LOG "ERR: The directory $directoryName does not exist. \n" .
          "ERR: Are you using the proper AE title for MPPS ? \n";
    return @rtnMPPS;
  }

  opendir MPPS, $directoryName  or die "directory: $directoryName not found!";
  @mppsDirectories = readdir MPPS;
  closedir MPPS;

  my $mppsIDX = 0;

  ENTRY: foreach $d (@mppsDirectories) {
    next ENTRY if ($d eq ".");
    next ENTRY if ($d eq "..");

    $f = "$directoryName/$d/$mppsMessageType.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if ($logLevel >= 3);
    next ENTRY if (! (-e $f));

    $id = `$main::MESA_TARGET/bin/dcm_print_element 0020 000D $f`;
    chomp $id;
    print main::LOG " $f <$id> \n" if ($logLevel >= 3);

    if ($uid eq $id) {
      $rtnMPPS[$mppsIDX] = "$directoryName/$d";
      $mppsIDX++;
    }
  }

#  return @mpps;
  return @rtnMPPS
}

sub getOpenSCRequestsHash {
  my ($logLevel, $commitDir) = @_;

  my %h = ();
  my @fileList = mesa_get::getDirectoryListFullPath($logLevel, $commitDir);
  return %h if (scalar(@fileList) == 0);

  foreach $f(@fileList) {
    $idx = 1;
    $done = 0;
    while ($done == 0) {
      ($x, $sopClass) = mesa_get::getDICOMValue($logLevel, $f, "0008 1199", "0008 1150", $idx);
      ($x, $sopInst)  = mesa_get::getDICOMValue($logLevel, $f, "0008 1199", "0008 1155", $idx);
      if ($x == 0 && $sopInst ne "") {
	$h{$sopInst} = $sopClass;
      } else {
	$done = 1;
      }
      $idx += 1;
    }
  }
  return %h;
}

1;
