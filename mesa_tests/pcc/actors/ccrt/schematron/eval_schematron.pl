#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub promptForFile()
{
  print "Please enter full path to document \n" .
        " --> ";
  $response = <STDIN>;
  chomp $response;
  exit(1) if ($response eq "");
  return $response;
}

sub x_1 {
  my ($logLevel, $testNumber, $file) = @_;
  print LOG "\nCTX: Care Record Summary $testNumber.1\n";
  print LOG "CTX: Evaluation using Schematron\n";

  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN $testNumber/sch_$testNumber.xml -XSL schematron/schematron-basic.xsl -OUT $testNumber/$testNumber.xsl -PARAM diagnose yes";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN $file -XSL $testNumber/$testNumber.xsl -OUT $testNumber/schematron_$testNumber.log";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  return 1 if $?;
  return 0;
}

sub appendResult {
  open RESULT, "$testNumber/schematron_$testNumber.log" or die "Could not open output file $testNumber/schematron_$testNumber.log";
  print LOG "\n\nResult from schematron validation:\n";
  while (<RESULT>) {
	s/^\s+//;
	print LOG "$_";
  } 
  print LOG "\n";
}

# Main starts here

 die "Usage: perl schematron/eval_schematron.pl TEST_NUMBER log_level FILE" if (scalar(@ARGV) < 2);
 $testNumber = $ARGV[0];
 $logLevel = $ARGV[1];

 open LOG, ">$testNumber/grade_$testNumber.txt" or die "Could not open output file $testNumber/grade_$testNumber.txt";
 my $mesaVersion = mesa_get::getMESAVersion();
 my $numericVersion = mesa_get::getMESANumericVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
 print LOG "CTX: Test:    $testNumber\n";
 print LOG "CTX: Actor:   CONTENT_CREATOR\n";
 print LOG "CTX: Version: $numericVersion\n";
 print LOG "CTX: Date:    $date\n";


 my $fileName;
 if (scalar(@ARGV) > 2) {
  $fileName = $ARGV[2];
 } else {
  $fileName = promptForFile();
 }
 
 my $diff = 0;
 $diff += x_1($logLevel, $testNumber, $fileName);

 appendResult();
 close LOG;

 $diff = mesa_evaluate::readErrorCount($logLevel, "$testNumber/grade_$testNumber.txt");

 if ($logLevel != 4) {
   $diff += 1;
   my $xString="ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
   print $xString;
  
 }


 mesa_evaluate::copyLogWithXML("$testNumber/grade_$testNumber.txt", "$testNumber/mir_mesa_$testNumber.xml",
        $logLevel, "$testNumber", "CONTENT_CREATOR", $numericVersion, $date, $diff);

 if ($diff == 0) {
   print "\nThis test completed with zero errors; that means successful test\n";
 } else {
   print "Test detected $diff errors; this implies a failure\n";
   print " Please consult $testNumber/grade_$testNumber.txt and $testNumber/mir_mesa_$testNumber.xml\n";
 }

 print "If you are submitting a result file to Kudu, submit $testNumber/mir_mesa_$testNumber.xml\n\n";

