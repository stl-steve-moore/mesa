#!/usr/local/bin/perl
#
# Script generates Image and MPPS files for the
# IHE Group case when there are 2 requested procedures
# to be satisfied.

# Args:
#	MODALITY
#	AE TITle
#	Patient ID
#	Directory name for output
#	AE Title of MWL server
#	Host name for MWL query
#	Port number for MWL query
#	Scheduled Procedure Code 1
#	Scheduled Procedure Code 2
#	Performed Procedure Code
#	Input directory

use Env;
use lib "scripts";
require mod;

$x = scalar(@ARGV);
if ($x != 11) {
  print("This script requires 11 arguments: \n" .
" Modality (MR, CT, ...) \n" .
" AE Title of Modality \n" .
" Patient ID \n" .
" Output directory \n" .
" AE Title of MWL Server \n" .
" Host name of MWL Server \n" .
" Port number of MWL Server \n" .
" Scheduled Procedure Code 1 \n" .
" Scheduled Procedure Code 2 \n" .
" Performed Procedure Code \n" .
" Input directory \n");

exit 1;
}

$modality        = $ARGV[0];
$modalityAE      = $ARGV[1];
$patientID       = $ARGV[2];
$outputDirectory = "$MESA_STORAGE/modality/$ARGV[3]";
$mwlAE           = $ARGV[4];
$mwlHost         = $ARGV[5];
$mwlPort         = $ARGV[6];
$scheduledCode1  = $ARGV[7];
$scheduledCode2  = $ARGV[8];
$performedCode   = $ARGV[9];
$inputDirectory  = $ARGV[10];


print "Removing previous results (if any) $outputDirectory\n";
mod::delete_directory($outputDirectory);
print "Creating output directory (if necessary) \n";
mod::create_directory($outputDirectory);

print "Clear the mwl/results directory \n";
mod::delete_directory("mwl/results");
mod::create_directory("mwl/results");


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

$xStatement = "$MESA_TARGET/bin/mod_generatestudy -g -m $modality -p $patientID " .
 " -s $scheduledCode1 -s $scheduledCode2 -c $performedCode " .
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

