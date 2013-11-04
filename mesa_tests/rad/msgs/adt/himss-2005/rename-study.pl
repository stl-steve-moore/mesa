#!/usr/bin/perl

use Env;

sub readImages {
  my ($dirName) = @_;

  opendir DIR, $dirName or die "Could not open directory: $dirName\n";

  my @imageFiles = readdir DIR;
  closedir DIR;

  return @imageFiles;
}

sub getNewStudyUID {
  my $x = "$MESA_TARGET/bin/mesa_identifier mod1 study_uid";
  my $y = `$x`;
  die "Could not generate Study Instance UID $x\n" if $?;
  chomp $y;
  return $y;
}

sub getNewSeriesUID {
  my $x = "$MESA_TARGET/bin/mesa_identifier mod1 series_uid";
  my $y = `$x`;
  die "Could not generate Series Instance UID $x\n" if $?;
  chomp $y;
  return $y;
}

sub getNewSOPUID {
  my $x = "$MESA_TARGET/bin/mesa_identifier mod1 sop_inst_uid";
  my $y = `$x`;
  die "Could not generate Series Instance UID $x\n" if $?;
  chomp $y;
  return $y;
}

sub processSeries {
  my ($patientName, $patientID, $DOB, $studyUID, $seriesUID) = @_;
  my $newSeriesUID = getNewSeriesUID();
  print "$patientName, $patientID, $studyUID $seriesUID $newSeriesUID\n";

  my $idx = 0;
  @sopUIDs = readImages($seriesUID);
IMAGE:  foreach $image(@sopUIDs) {
    next IMAGE if ($image eq ".");
    next IMAGE if ($image eq "..");
    next IMAGE if ($idx > 20);
    $idx += 1;

    my $newSOPUID = getNewSOPUID();

    open DELTA, ">delta.txt" or die "Could not open delta file\n";
    print DELTA "AA 0008 0018 $newSOPUID\n";
    print DELTA "AA 0008 0050\n";
    print DELTA "AA 0020 000D $studyUID\n";
    print DELTA "AA 0020 000E $newSeriesUID\n";
    print DELTA "AA 0010 0010 $patientName\n";
    print DELTA "AA 0010 0020 $patientID\n";
    print DELTA "AA 0010 0030 $DOB\n";
    print DELTA "AA 0010 0040 M\n";
    print DELTA "RA 0008 2112 \n";
    print DELTA "RA 0040 0275 \n";
    close DELTA;
    my $z = "$MESA_TARGET/bin/cstore -c DICOM_STORAGE -d delta.txt localhost 2000 $seriesUID/$image ";
#    print "$z\n";
    print `$z`;
    die "Could not store image: $z\n" if $?;
  }
}

  

my $patientName = $ARGV[0];
my $patientID = $ARGV[1];
my $DOB = $ARGV[2];

my $studyUID = getNewStudyUID();
print "$patientName, $patientID, $studyUID\n";

my $idx = 0;
for ($idx = 3; $idx < scalar(@ARGV); $idx += 1) {
  processSeries($patientName, $patientID, $DOB, $studyUID, $ARGV[$idx]);
}

exit 0;


