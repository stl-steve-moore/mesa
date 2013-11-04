#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by an Image Creator for test 513.

use Env;
use lib "scripts";
require imgcrt;

sub x_513_1 {
  print LOG "Image Creator Test 513.1 \n";
  print LOG " Evaluation of Key Image Note\n";

  my $verbose = shift(@_);

  my $masterFile = "../../msgs/sr/513/sr_513_mr.dcm";

  my @testObjects = imgcrt::find_images_by_patient_sop_class($verbose, "MR3",
	"1.2.840.10008.5.1.4.1.1.88.59");

  $count = scalar(@testObjects);
  print LOG "Found $count objects for Patient ID CR3\n" if $verbose;
  print LOG "We will evaluate the first Key Object Note we find\n" if $verbose;

  if ($count == 0) {
    print LOG "No objects are found for Patient ID CR3\n";
    print LOG "Please load images and create the Key Object Note\n";
    return 1;
  }


  $testFile = $testObjects[0];
  print LOG "$testFile \n" if $verbose;

  $rtnValue = imgcrt::eval_key_image($verbose,
		$masterFile, $testFile,
		"513/sr_513.ini", "513/sr_513_req.txt");

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 1) {
  print "This script takes one argument: <AE title of Image Creator> \n";
  exit 1;
}

#$aeTitle = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">513/grade_513.txt" or die "?!";
$diff = 0;

$diff += x_513_1($verbose);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 513/grade_513.txt \n";

exit $diff;
