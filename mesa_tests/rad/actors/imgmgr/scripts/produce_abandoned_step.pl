#!/usr/local/bin/perl

use Env;
use lib "scripts";
require imgmgr;

# Generate Image and MPPS files for a set of Images
#  for IHE abandoned case.
# Args:
#	MODALITY
#	AE TITle
#	Patient ID
#	Procedure Code
#	Directory name (might be close to procedure Code)
#	AE Title of MWL server
#	Host name for MWL query
#	Port number for MWL query
#	Scheduled Procedure Code
#	Performed Procedure Code
#	Input directory
#	Code for reason for discontinued procedure step

$x = scalar(@ARGV);
if ($x != 12) {
  print("This script requires 12 arguments: \n" .
" Modality (MR, CT, ...) \n" .
" AE Title of Modality \n" .
" Patient ID \n" .
" Procedure Code \n" .
" Output directory \n" .
" AE Title of MWL Server \n" .
" Host name of MWL Server \n" .
" Port number of MWL Server \n" .
" Scheduled Procedure Code \n" .
" Performed Procedure Code \n" .
" Input directory \n" .
" Code for discontinue reason");

exit 1;
}

$modality = $ARGV[0];
$modalityAE = $ARGV[1];
$patientID = $ARGV[2];
if ($MESA_OS eq "WINDOWS_NT") {
  $outputDirectory = "$MESA_STORAGE\\modality\\$ARGV[4]";
} else {
  $outputDirectory = "$MESA_STORAGE/modality/$ARGV[4]";
}
$mwlAE = $ARGV[5];
$mwlHost = $ARGV[6];
$mwlPort = $ARGV[7];
$scheduledCode = $ARGV[8];
$performedCode = $ARGV[9];
$inputDirectory = $ARGV[10];
$discontinueCode = $ARGV[11];

print "Removing previous results (if any) $outputDirectory\n";
mesa::delete_directory(1, $outputDirectory);
print "Creating output directory (if necessary) \n";
mesa::create_directory(1, $outputDirectory);

print "Clear the mwl/results directory \n";
mesa::delete_directory(1, "mwl/results");
mesa::create_directory(1, "mwl/results");

print "Creating MWL query to retrieve worklist \n";
if (! (-e "mwl/mwlquery.txt") ) {
  print "The file mwl/mwlquery.txt does not exist.  Installation error. \n";
  exit 1;
}

$x = "$MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm";
print "$x \n";
print `$x`;
if ($? != 0) {
  print "Unable to create mwl/mwlquery.dcm.  Permission or other problem. \n";
  exit 1;
}

open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID \n";
print PIDFILE "0010 0020 $patientID \n";
close PIDFILE;

open MWLOUTPUT, ">mwlquery.out";

print MWLOUTPUT `$MESA_TARGET/bin/mwlquery -a $modalityAE -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort`;
if ($?) {
  print "Unable to obtain MWL from $mwlHost at port $mwlPort with AE title $mwlAE \n";
  exit 1;
}

close MWLOUTPUT;

$xStatement = "$MESA_TARGET/bin/mod_generatestudy -m $modality -p $patientID " .
 " -D $discontinueCode " .
 " -s $scheduledCode -c $performedCode " .
 " -i $MESA_STORAGE/modality/$inputDirectory " .
 " -t $outputDirectory " .
 " -y mwl/results " .
 " -z \"IHE Protocol 1\" ";

print "$xStatement \n";

open STUDYOUT, ">generatestudy.out";

print STUDYOUT "$xStatement \n";

print STUDYOUT `$xStatement`;

if ($?) {
  print "Unable to create images/PPS from MWL.  Look in generatestudy.out \n";
  exit 1;
}

exit 0;

