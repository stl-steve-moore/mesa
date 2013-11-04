#!/usr/local/bin/perl

use Env;
use lib "scripts";
require imgmgr;

# Generate Image and MPPS files for a set of Images (unscheduled case)
# Args:
#	MODALITY
#	AE TITle
#	Patient ID
#	Procedure Code
#	Output Directory name (might be close to procedure Code)
#	Performed Code
#	Input Directory
#	Patient Name

$x = scalar(@ARGV);
if ($x != 8) {
  print("This script requires 8 arguments: \n" .
" Modality (MR, CT, ...) \n" .
" Modality AE Title \n" .
" Patient ID \n" .
" Procedure Code \n" .
" Output directory name (usually same as Procedure Code) \n" .
" Performed AI Code \n" .
" Input Directory \n" .
" Patient Name \n");
  exit 1;
}

$xModality = $ARGV[0]; 
$xAETitle = $ARGV[1];
$xPatientID = $ARGV[2];
$xProcedureCode = $ARGV[3];

if ($MESA_OS eq "WINDOWS_NT") {
 $xOutputDirectory = "$MESA_STORAGE\\modality\\$ARGV[4]";
} else {
 $xOutputDirectory = "$MESA_STORAGE/modality/$ARGV[4]";
}

$xPerformedAICode = $ARGV[5];
$xInputDirectory = $ARGV[6];
$xPatientName = $ARGV[7];

#echo "Clearing the Modality Database (and UIDS)"
#pushd $MESA_TARGET/db
#./ClearModTables.script mod1 >& /dev/null
#popd

print "Removing previous results (if any) $xOutputDirectory \n";
mesa::delete_directory(1, $xOutputDirectory);
print "Creating output directory \n";
mesa::create_directory(1, $xOutputDirectory);

$xStatement = "$MESA_TARGET/bin/mod_generatestudy -m $xModality " .
 " -p $xPatientID " .
 " -r $xPatientName " .
 " -c $xPerformedAICode " .
 " -i $MESA_STORAGE/modality/$xInputDirectory " .
 " -t $xOutputDirectory " .
 " -z \"IHE Protocol 1\" ";

open STUDYOUT, ">generatestudy.out";

print STUDYOUT "$xStatement \n";

print STUDYOUT `$xStatement`;

if ($?) {
  print "Unable to create unscheduled images/PPS.  Look in generatestudy.out \n";
  exit 1;
}

exit 0;

