#!/usr/local/bin/perl -w

use Env;
use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub check_environment {
 if (! $JAVA_HOME) {
  die "You need to define the environment variable JAVA_HOME to point to your JDK installation";
 }
 if (! -e $JAVA_HOME) {
  die "Env variable JAVA_HOME $JAVA_HOME does not point to an existing folder";
 }
}

sub promptForFile()
{
  print "Please enter full path to document \n" .
        " --> ";
  $response = <STDIN>;
  chomp $response;
  exit(1) if ($response eq "");
  return $response;
}

sub x_40311_1 {
  print LOG "\nCTX: Care Record Summary 40311.1\n";
  print LOG "CTX: Evaluation using CRS Schematron\n";

  my ($logLevel, $file) = @_;

  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN 40311/40311_schematron.xml -XSL schematron/schematron-basic.xsl -OUT 40311/40311.xsl -PARAM diagnose yes";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN $file -XSL 40311/40311.xsl -OUT 40311/schematron_40311.log";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  return 1 if $?;
  return 0;
}

sub appendResult {
  open RESULT, "40311/schematron_40311.log" or die "Could not open output file 40311/schematron_40311.log";
  print LOG "\n\nResult from schematron validation:\n";
  while (<RESULT>) {
	print LOG "$_";
  } 
  print LOG "\n";
}
# Main starts here

 die "Usage: perl 40311/eval_40311.pl <log level> FILE" if (scalar(@ARGV) < 1);
 $logLevel = $ARGV[0];
 check_environment();

 open LOG, ">40311/grade_40311.txt" or die "Could not open output file 40311/grade_40311.txt";
 my $mesaVersion = mesa_get::getMESAVersion();
 my $numericVersion = mesa_get::getMESANumericVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Test:    40311\n";
print LOG "CTX: Actor:   CONTENT_CREATOR\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

 my $fileName;
 if (scalar(@ARGV) > 1) {
  $fileName = $ARGV[1];
 } else {
  $fileName = promptForFile();
 }
 
 my $diff = 0;
 $diff += x_40311_1($logLevel, $fileName);

 appendResult();
 close LOG;
 $diff = mesa_evaluate::readErrorCount($logLevel, "40311/grade_40311.txt");


if ($diff == 0) {
  print "\nCTX: 0 errors implies this test has been passed.\n";
} else {
  print "\nERR: $diff errors implies test FAILURE.\n";
}

open LOG, ">40311/mir_mesa_40311.xml" or die "Could not open XML output file: 40311/mir_mesa_40311.xml";


mesa_evaluate::eval_XML_start($logLevel, "40311", "CONTENT_CREATOR", $numericVersion, $date);
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);

if ($logLevel != 4) {
  $diff += 1;
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}
mesa_evaluate::startDetails($logLevel);

open TMP, "<40311/grade_40311.txt" or die "Could not open 40311/grade_40311.txt
for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 40311/grade_40311.txt \n";
print "Submit 40311/mir_mesa_40311.xml for grading\n";
exit $diff;

exit 0;


