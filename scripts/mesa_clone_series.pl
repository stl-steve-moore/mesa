#!/usr/local/bin/perl -w

# This script clones a DICOM series of images
# by reading the files, changing the DICOM UIDs
# and writing new files.

use Env;

sub scanSeriesDirectory {
  my ($inputDir) = @_;
  opendir D, $inputDir or die "Could not open: $inputDir\n";
  @fileNames = readdir D;
  closedir D;
  $i = 0;
  IMAGE: foreach $f(@fileNames) {
    next IMAGE if ($f eq "." || $f eq "..");
    $rtnImages[$i] = "$inputDir/$f";
    $i += 1;
  }
  return @rtnImages;
}

sub checkInputImages {
  foreach $f (@_) {
    print "$f \n";
  }
}

sub newSeriesInstanceUID {
  my $x = "mesa_identifier mod1 series_uid";
  my $y = `$x`;
  die "Could not produce Series UID\n" if ($?);
  chomp $y;
  return $y;
}

sub newSOPInstanceUID {
  my $x = "mesa_identifier mod1 sop_inst_uid";
  my $y = `$x`;
  die "Could not produce SOP Instance UID\n" if ($?);
  chomp $y;
  return $y;
}

sub processImages {
  my $studyInstanceUID = shift(@_);
  my $outputDir        = shift(@_);

  my $seriesInstanceUID = newSeriesInstanceUID();
  my $path = "$outputDir/$seriesInstanceUID";
  `mkdir -p $path`;
  

  foreach $f(@_) {
    my $sopInstanceUID = newSOPInstanceUID();
    open DELTA, ">/tmp/delta.txt" or die "Cannot file /tmp/delta.txt";
    print DELTA "0020 000D $studyInstanceUID\n";
    print DELTA "0020 000E $seriesInstanceUID\n";
    print DELTA "0008 0018 $sopInstanceUID\n";
    close DELTA;
    print "$f $path/$sopInstanceUID\n";
    my $x1 = "dcm_modify_object -i /tmp/delta.txt $f /tmp/image.dcm";
    `$x1`;
    die "Could not process $f\n" if ($?);

    my $x2 = "dcm_rm_element 0008 1140 /tmp/image.dcm $path/$sopInstanceUID";
    `$x2`;
    die "Could not process $f\n" if ($?);
  }
  return 0;
}

die "Usage: mesa_clone_series <input DIR> <output DIR> <study UID> \n" if (scalar(@ARGV) < 3);

## Main starts here

 $inputDir = $ARGV[0];
 $outputDir = $ARGV[1];
 $studyInstanceUID = $ARGV[2];

 @inputImages = scanSeriesDirectory($inputDir);
 # checkInputImages(@inputImages);
 processImages($studyInstanceUID, $outputDir, @inputImages);
 exit 0;
