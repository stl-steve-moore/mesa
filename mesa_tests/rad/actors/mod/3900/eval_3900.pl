#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require "mesa_get.pm";
require "mesa_evaluate.pm";

#require "../../../common/scripts/mesa_get.pm";
#require "../../../common/scripts/mesa_evaluate.pm";

use lib "../common/scripts";
#require "evaluate_fusion.pm";

sub goodbye() {
  exit 1;
}

# Evaluate "For Presentation" image attributes
sub x_3900_1 {
 my $errorCount = 0;
 print LOG "\n\nCTX: Acq. Modality: 3900.1 \n";
 print LOG "CTX:  Evaluate \"For Presentation\" images\n";
 
 ($status, @x) = mesa_get::getSOPInstanceFileNamesByClauidAttribute($logLevel, "imgmgr", "clauid" , "1.2.840.10008.5.1.4.1.1.1.2");
 if ($status != 0) {
      print LOG "ERR: Could not get SOP Instance list from MESA imgmgr database\n";
      return 1;
 }
 if (scalar(@x) == 0) {
      print LOG "ERR: 0 SOP Instances stored to MESA Image Manager with class uid 1.2.840.10008.5.1.4.1.1.1.2\n";
      return 1;
 }else{
      foreach my $file (@x) {
	#print LOG "$_\n";
      $errorCount = mesa_evaluate::eval_mammo_presentation_image(
					$logLevel,
					$file,
					);
      }
 }
 return $errorCount;
}

# Evaluate "for Processing" image attributes
sub x_3900_2 {
 my $errorCount = 0;
 print LOG "\n\nCTX: Acq. Modality: 3900.2 \n";
 print LOG "CTX:  Evaluate \"For Processing\" images\n";
 
 ($status, @x) = mesa_get::getSOPInstanceFileNamesByClauidAttribute($logLevel, "imgmgr", "clauid" , "1.2.840.10008.5.1.4.1.1.1.2.1");
 if ($status != 0) {
      print LOG "ERR: Could not get SOP Instance list from MESA imgmgr database\n";
      return 1;
 }
 if (scalar(@x) == 0) {
      print LOG "ERR: 0 SOP Instances stored to MESA Image Manager with class uid 1.2.840.10008.5.1.4.1.1.1.2.1\n";
      return 1;
 }else{
      foreach my $file (@x) {
	#print LOG "$_\n";
      my $digitizer = 0;
      $errorCount = mesa_evaluate::eval_mammo_processing_image(
					$logLevel,
					$file,
 					$digitizer
					);
      }
 }
 return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel = $ARGV[0];
open LOG, ">3900/grade_3900.txt" or die "?!";
$diff = 0;

$diff += x_3900_1;
$diff += x_3900_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3900/grade_3900.txt \n";

exit $diff;
