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

# Evaluate mammo image with Partial View attributes
sub x_3915_1 {
 my $errorCount = 0;
 print LOG "\n\nCTX: Acq. Modality: 3915.1 \n";
 print LOG "CTX:  Evaluate mammo image \"with Partial View\"\n";
 
 ($status, @x) = mesa_get::getSOPInstanceFileNamesByClauidAttribute($logLevel, "imgmgr", "clauid" , "1.2.840.10008.5.1.4.1.1.1.2.1");
 if ($status != 0) {
      print LOG "CTX: Could not get SOP Instance list from MESA imgmgr database\n";
 }
 ($status, @y) = mesa_get::getSOPInstanceFileNamesByClauidAttribute($logLevel, "imgmgr", "clauid" , "1.2.840.10008.5.1.4.1.1.1.2");
 if ($status != 0) {
      print LOG "CTX: Could not get SOP Instance list from MESA imgmgr database\n";
 }
 if ((scalar(@x) || scalar(@y))== 0) {
      print LOG "ERR: 0 SOP Instances stored to MESA Image Manager with class uid 1.2.840.10008.5.1.4.1.1.1.2.1 or with class uid 1.2.840.10008.5.1.4.1.1.1.2\n";
      return 1;
 }else{
      push (@x,@y);
      foreach my $file (@x) {
	#print LOG "$_\n";
      $errorCount = mesa_evaluate::eval_mammo_partialview_image(
					$logLevel,
					$file,
					);
      }
 }
 return $errorCount;
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel = $ARGV[0];
open LOG, ">3915/grade_3915.txt" or die "?!";
$diff = 0;

$diff += x_3915_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3915/grade_3915.txt \n";

exit $diff;
