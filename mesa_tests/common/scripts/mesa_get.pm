#!/usr/local/bin/perl -w

# General GET package for MESA scripts.

use Env;

package mesa_get;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub getMESAVersion {
  open(H, "< $main::MESA_TARGET/runtime/version.txt") || return "Unable to open $main::MESA_TARGET/runtime/version.txt";

  my $ v = <H>;
  chomp $v;
  return $v;
}

sub getMESANumericVersion {
  my $a = getMESAVersion();
  ($x, $y, $z) = split(" ", $a);
  return $z;
}

sub get_config_params {
  my $f = shift(@_);
  die "Error: No config filename specified.\n" unless (defined $f);

  my ($line, $varname, $varvalue);

  open (CONFIGFILE, $f ) or die "Can't open $f .\n";
  $delimiter = "=";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = trim_whitespace(split($delimiter, $line));
    if ($varname eq "DELIMITER") {
      $delimiter = $varvalue;
    } else {
      $varnames{$varname} = $varvalue;
    }
  }

  return %varnames;
}

# Usage: getHL7Field(log level, file name, segment name, field number,
#               component, field name, version)
#	Segment name	3 character segment name
#	Field Number	1-N
#	Component	0 = all, 1, 2, 3... subcomponent
#	Field Name	For debugging
#	Version		HL7 version (2.3.1, 2.4, 2.5)
# returns:
#  (0, value) on success
#  (1, "") on failure


sub getHL7Field {
  my ($logLevel, $hl7File, $seg, $field, $comp, $fieldName, $version) = @_;

  my $d = "ihe";
  $d = "ihe-iti" if ($version eq "2.4");
  $d = "ihe-iti" if ($version eq "2.5");

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -d $d -f $hl7File $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  if ($?) {
    print "Could not get $fieldName from $hl7File \n";
    return (1, "");
  }

  chomp $y;
  return (0, $y);
}

sub getHL7FieldRepeatedSegment {
  my ($logLevel, $hl7File, $seg, $segIndex, $field, $comp, $fieldName, $version) = @_;

  my $d = "ihe";
  $d = "ihe-iti" if ($version eq "2.4");
  $d = "ihe-iti" if ($version eq "2.5");

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -i $segIndex -d $d -f $hl7File $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  if ($?) {
    print "Could not get $fieldName from $hl7File \n";
    return (1, "");
  }

  chomp $y;
  return (0, $y);
}

sub getDirectoryList {
  my ($logLevel, $dir) = @_;

  print "mesa_get::getDirectoryList read directory $dir\n" if ($logLevel >= 3);

  opendir T, $dir or die "mesa_get::getDirectoryList could not open directory: $dir";
  @files = readdir T;
  closedir T;

  my @rtnFiles;
  my $idx = 0;
  FILENAME: foreach $f(@files) {
    next FILENAME if ($f eq "." || $f eq "..");
    $rtnFiles[$idx] = $f;
    $idx += 1;
  }
  return @rtnFiles;
}

sub getDirectoryListFullPath {
  my ($logLevel, $dir) = @_;

  print "mesa_get::getDirectoryList read directory $dir\n" if ($logLevel >= 3);

  opendir T, $dir or die "mesa_get::getDirectoryList could not open directory: $dir; implies a mistyped parameter or a MESA bug";
  @files = readdir T;
  closedir T;

  my @rtnFiles;
  my $idx = 0;
  FILENAME: foreach $f(@files) {
    next FILENAME if ($f eq "." || $f eq "..");
    $rtnFiles[$idx] = $dir . "/" . $f;
    $idx += 1;
  }
  return @rtnFiles;
}

sub getDirectoryListFullPathByExtension {
  my ($logLevel, $extension, $dir) = @_;

  print "mesa_get::getDirectoryList read directory $dir\n" if ($logLevel >= 3);

  opendir T, $dir or die "mesa_get::getDirectoryList could not open directory: $dir";
  @files = readdir T;
  closedir T;

  my @rtnFiles;
  my $idx = 0;
  FILENAME: foreach $f(@files) {
    next FILENAME if ($f eq "." || $f eq "..");
    next FILENAME if ! ($f =~ /$extension/);
    $rtnFiles[$idx] = $dir . "/" . $f;
    $idx += 1;
  }
  return @rtnFiles;
}

sub getDateTime {
  my ($logLevel) = @_;

  @timeData = localtime(time);
  my $yyyy = $timeData[5] + 1900;
  my $mm   = $timeData[4] + 1;
  my $dd   = $timeData[3];
  if ($mm <= 9) {
    $mm = "0" . $mm;
  }
  if ($dd <= 9) {
    $dd = "0" . $dd;
  }
  my $hour = $timeData[2]; $hour = "0" . $hour if ($hour <= 9);
  my $min  = $timeData[1]; $min  = "0" . $min  if ($min  <= 9);
  my $sec  = $timeData[0]; $sec  = "0" . $sec  if ($hour <= 9);

  my $date = "$yyyy$mm$dd";
  my $timeToMinute = "$hour$min";
  my $timeToSec = "$hour$min$sec";
  return (0, $date, $timeToMinute, $timeToSec);
}

sub getHostName {
  my ($logLevel) = @_;

  my $x = `hostname`;
  return (0, "unknown") if $?;

  chop $x;

  return (0, $x);
}

sub getDICOMValue {
  my ($logLevel, $fileName, $sequenceTag, $tag, $idx) = @_;
  my $x;

  die "mesa_get::getDICOMValue could not find DICOM file: $fileName" if (! -e $fileName);

  if ($sequenceTag ne "") {
      if (! $idx) {
        $idx = 1;
      }
      $x = "$main::MESA_TARGET/bin/dcm_print_element -i $idx -s $sequenceTag $tag $fileName";
  } else {
      $x = "$main::MESA_TARGET/bin/dcm_print_element $tag $fileName";
  }
  print "$x\n" if ($logLevel >= 3);

  my $v = `$x`;
  if ($?) {
      warn "Could not get DICOM attribute $tag from file $fileName " if $logLevel >= 2;
      return (1, 0);
  }
  chomp $v;
  return (0, $v);
}

sub getDICOMValueSequence {
  my ($logLevel, $fileName, $seqTag1, $seqTag2, $tag) = @_;
  my $x;

  die "mesa_get::getDICOMValue could not find DICOM file: $fileName" if (! -e $fileName);

  $x = "$main::MESA_TARGET/bin/dcm_print_element -z $seqTag1 $seqTag2 $tag $fileName";
  print "$x\n" if ($logLevel >= 3);

  my $v = `$x`;
  if ($?) {
      warn "Could not get DICOM attribute $tag from file $fileName " if $logLevel >= 2;
      return (1, 0);
  }
  chomp $v;
  return (0, $v);
}

sub getDICOMNMImageType {
  my ($logLevel, $fileName) = @_;

  my $status = 0;
  my $x = 0;
  my $type = "";
  my $str = "";

  ($x, $str) = mesa_get::getDICOMValue($logLevel, $fileName, "", "0008 0008", 0);
  @components = split /\\/,$str;

  if (! $components[2]) {
    return (1, "");
  }

  if ($components[2] eq "STATIC") {
    return (0, "GeneralStatic");
  }

  if ($components[2] eq "TOMO") {
    ($x, $str) = mesa_get::getDICOMValueSequence($logLevel, $fileName,
	"0040 0555", "0040 A043", "0008 0100");
    if ($x == 1) { return (0, "GeneralTOMO") };
    if ($str eq "") { return (0, "GeneralTOMO") };
    return (0, "CardiacTOMO");
  }

  if ($components[2] eq "GATED TOMO") {
    return (0, "CardiacGatedTOMO");
  }

  if ($components[2] eq "DYNAMIC") {
    ($x, $str) = mesa_get::getDICOMValueSequence($logLevel, $fileName,
	"0040 0555", "0040 A043", "0008 0100");
    if ($x == 1) { return (0, "GeneralDynamic") };
    if ($str eq "") { return (0, "GeneralDynamic") };
    return (0, "CardiacDynamic");
  }

  if ($components[2] eq "GATED") {
    ($x, $str) = mesa_get::getDICOMValueSequence($logLevel, $fileName,
	"0040 0555", "0040 A043", "0008 0100");
    if ($x == 1) { return (0, "GeneralGated") };
    if ($str eq "") { return (0, "GeneralGated") };
    return (0, "CardiacGated");
  }

  if ($components[2] eq "RECON TOMO") {
    ($x, $str) = mesa_get::getDICOMValueSequence($logLevel, $fileName,
	"0040 0555", "0040 A043", "0008 0100");
    if ($x == 1) { return (0, "GeneralReconTOMO") };
    if ($str eq "") { return (0, "GeneralReconTOMO") };
    return (0, "CardiacReconTOMO");
  }

  if ($components[2] eq "WHOLE BODY") {
    ($x, $str) = mesa_get::getDICOMValueSequence($logLevel, $fileName,
	"0040 0555", "0040 A043", "0008 0100");
    if ($x == 1) { return (0, "GeneralWholeBody") };
    if ($str eq "") { return (0, "GeneralWholeBody") };
    return (0, "CardiacWholeBody");
  }

  return ($status, $components[2]);
}

sub getIdentifier {
  my ($logLevel, $dbName, $identifierType) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName $identifierType";
  print "$x\n" if ($logLevel >= 3);

  my $rtnStatus = 0;
  my $y = `$x`;
  $rtnStatus = 1 if ($?);
  chomp $y;
  return ($rtnStatus, $y);
}

sub getSOPInstanceFileNames {
  my ($logLevel, $dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_select_column filnam sopins $dbName filnam.txt";
  print "$x\n" if ($logLevel >= 3);

  my @fileNames;
  my $rtnStatus = 0;

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return (1, @fileNames) if ($?);

  open (H, "<filnam.txt") or die "mesa_get::xxx Could not open filnam.txt";
  $idx = 0;
  while ($line = <H>) {
    chomp $line;
    next if ($line eq "." or $line eq "..");

    $fileNames[$idx] = $line;
    $idx += 1;
  }
  return (0, @fileNames);
}

sub getSOPInstanceFileNamesByPatientAttribute {
  my ($logLevel, $dbName, $col, $val) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c $col $val filnam sopins_view $dbName filnam.txt";
  print "$x\n" if ($logLevel >= 3);

  my @fileNames;
  my $rtnStatus = 0;

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return (1, @fileNames) if ($?);

  open (H, "<filnam.txt") or die "mesa_get::getSOPInstanceFileNamesByPatientAttribute Could not open filnam.txt";
  $idx = 0;
  while ($line = <H>) {
    chomp $line;
    next if ($line eq "." or $line eq "..");

    $fileNames[$idx] = $line;
    $idx += 1;
  }
  return (0, @fileNames);
}

sub getSOPInstanceFileNamesByClauidAttribute {
  my ($logLevel, $dbName, $col, $val) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c $col $val filnam sopins $dbName filnam.txt";
  print "$x\n" if ($logLevel >= 3);

  my @fileNames;
  my $rtnStatus = 0;

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return (1, @fileNames) if ($?);

  open (H, "<filnam.txt") or die "mesa_get::getSOPInstanceFileNamesByClauidAttribute Could not open filnam.txt";
  $idx = 0;
  while ($line = <H>) {
    chomp $line;
    next if ($line eq "." or $line eq "..");

    $fileNames[$idx] = $line;
    $idx += 1;
  }
  return (0, @fileNames);
}

sub get_mpps_uid_from_text {
  my ($logLevel, $file) = @_;

  print "mesa_get::get_mpps_uid_from_text looking for UID in file: $file\n" if ($logLevel >= 3);

  
  open(H, "< $file") || return (1, "Unable to open $file");
  my $ v = <H>;
  chomp $v;
  return (0, $v);
}

sub getOpenSCRequests {
  my ($logLevel, $aeTitleNEventSCU) = @_;

  $aeTitleNEventSCU =~ s/\s+$//;
  my $scDir = "$main::MESA_STORAGE/imgmgr/commit/$aeTitleNEventSCU";
  opendir SCDIR, $scDir or die "directory: $scDir not found!\n";
  @scFiles = readdir SCDIR;
  closedir SCDIR;

  undef @rtnFiles;
  my $idx = 0;
  foreach $sc(@scFiles) {
    if ($sc =~ /.opn/) {
      $rtnFiles[$idx] = $scDir . "/" . $sc;
      $idx++;
    }
  }
  return (0, @rtnFiles);
}

sub getStorageCommitNEventHash {
  my ($logLevel, $storagePath) = @_;

  $testDir = "$main::MESA_STORAGE/$storagePath";
  print main::LOG "CTX path to SC request: $testDir\n" if ($logLevel >= 3);

  opendir TESTDIR, $testDir or die "directory: $testDir not found! Check that $main::MESA_STORAGE/$storagePath exists";
  @testFiles = readdir TESTDIR;

  my %testMessages;
  MESSAGE: foreach $message (@testFiles) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $z = "$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message";    print main::LOG  "CTX: $z \n"  if ($logLevel >= 3);
    $x = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message`;    chomp $x;
    next MESSAGE if ($x eq "");

    print ("$x \n") if ($verbose);
    $testMessages{$x} = "$testDir/$message";
  }
  return %testMessages;
}

sub getStorageCommitNEventArray {
  my ($logLevel, $storagePath) = @_;

  $testDir = "$main::MESA_STORAGE/$storagePath";
  print main::LOG "CTX path to SC request: $testDir\n" if ($logLevel >= 3);

  opendir TESTDIR, $testDir or die "directory: $testDir not found! Check that $main::MESA_STORAGE/$storagePath exists";
  @testFiles = readdir TESTDIR;

  my @testMessages;
  my $idx = 0;
  MESSAGE: foreach $message (@testFiles) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");
    $testMessages[$idx] = "$testDir/$message";
  }
  return @testMessages;
}

sub getReferencedSOPSequence {
  my ($logLevel, $path) = @_;
  my $done = 0;
  my $idx = 1;
  my $value = "";
  my @v;
  while (! $done) {
    my ($s1, $instanceUID) = mesa_get::getDICOMValue($logLevel, $path, "0008 1199", "0008 1150", $idx);
    my ($s2, $classUID) = mesa_get::getDICOMValue($logLevel, $path, "0008 1199", "0008 1155", $idx);
    if ($instanceUID eq "") {
      $done = 1;
    } else {
      $x = $classUID . ":" . $instanceUID;
      $v[$idx-1] = $x;
    }
    $idx++;
  }
  return (0, @v);
}

sub getSOPInstancesFromDB {
  my ($logLevel, $db) = @_;

  if (mesa_utility::create_directory($logLevel, "$main::MESA_STORAGE/scratch") != 0) {
    print "mesa_dicom::create_SPATIAL Could not create scratch directory $main::MESA_STORAGE/scratch\n";
    return 1;
  }

  my @sopInstances;
  my $x = "$main::MESA_TARGET/bin/mesa_select_column insuid sopins $db $main::MESA_STORAGE/scratch/sopins.txt";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  return (1, @sopInstances) if $?;

  open(H, "< $main::MESA_STORAGE/scratch/sopins.txt") ||
	die "Unable to open $main::MESA_STORAGE/scratch/sopins.txt";
  my $idx = 0;
  while ($line = <H>) {
   chomp($line);
   $sopInstances[$idx] = $line;
   $idx++;
  }
  return (0, @sopInstances);
}

sub getDICOMFileByTag {
  my ($logLevel, $tag, $value, @files) = @_;

  my $fileCount = scalar(@files);
  print "mesa_get::getDICOMFileByTag Tag <$tag> Value <$value> Files $fileCount\n" if ($logLevel >= 3);
  foreach $f(@files) {
    print "  $f\n" if ($logLevel >= 4);
    my ($x, $v) = mesa_get::getDICOMValue($logLevel, $f, "", $tag, 0);
    if ($x != 0) {
      print "mesa_get::getDICOMFileByTag could not get value for $tag from $f\n";
      return (1, "");
    }
    if ($value eq $v) {
      return (0, $f);
    }
  }
  print "No matching values for <$tag> <$value>\n";
  return (1, "");
}

## These are internal functions used above. Probably not of interest
## to others

# This subroutine courtesy of Perl Cookbook, ch. 1.14.  Strips whitespace from beginning and ends
# of strings in scalar or array context.
#   $str = trim_whitespace($str);
#   @many = trim_whitespace(@many);
sub trim_whitespace {
  my @out = @_;
  for (@out) {
    s/^\s+//;
    s/\s+$//;
  }
  return wantarray ? @out : $out[0];
}

sub find_mpps_dir_by_patient_id
{
  my $logLevel = shift(@_);
  my $aet = shift(@_);
  my $patientID = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "CTX: Searching for MPPS files in: $d \n" if ($logLevel >= 3);
  print main::LOG "CTX: Patient ID for MPPS files is $patientID \n" if ($logLevel >= 3);

  if (! -e $d) {
    print "Failure: The directory $d does not exist. \n" .
	  " Are you using the proper AE title for MPPS ? \n";
    print main::LOG "ERR: Failure: The directory $d does not exist.\n" .
	  "     Are you using the proper AE title for MPPS ? \n";
    exit 1;
  }

  opendir MPPS, $d  or die "directory: $d not found!";
  @mppsDirectories = readdir MPPS;
  closedir MPPS;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG "CTX: Searching $f for MPPS information. \n" if ($logLevel >= 3);
    next ENTRY if (! (-e $f));

    $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    print main::LOG "CTX: $f <$id> \n" if ($logLevel >= 3);

    if ($patientID eq $id) {
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
}

1;

