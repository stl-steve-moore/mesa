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

sub x_40111_0 {
  print LOG "\nCTX: PCC 40111.0\n";
  print LOG "CTX: Evaluation using PCC Schematron\n";

  my ($logLevel, $file) = @_;
  if (! -e $file) {
    print LOG "ERR: File does not exist: $file\n";
    return 1;
  }
  return 0;
}


sub x_40111_1 {
  print LOG "\nCTX: PCC 40111.1\n";
  print LOG "CTX: Evaluation using PCC Schematron\n";

  my ($logLevel, $file) = @_;

#  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN 40111/40111_schematron.xml -XSL schematron/schematron-basic.xsl -OUT 40111/40111.xsl -PARAM diagnose yes";
  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN schematron/pcctf-mesa.sch -XSL schematron/schematron-basic.xsl -OUT 40111/40111.xsl -PARAM diagnose yes";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN $file -XSL 40111/40111.xsl -OUT 40111/schematron_40111.log";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  return 1 if $?;
  return 0;
}

sub appendResult {
  open RESULT, "<40111/schematron_40111.log" or die "Could not open output file 40111/schematron_40111.log";
  print LOG "\n\nResult from schematron validation:\n";
  while (<RESULT>) {
	print LOG "$_";
  } 
  print LOG "\n";
}
# Main starts here

 die "Usage: perl 40111/eval_40111.pl <log level> FILE" if (scalar(@ARGV) < 1);
 $logLevel = $ARGV[0];
 check_environment();

 open LOG, ">40111/grade_40111.txt" or die "Could not open output file 40111/grade_40111.txt";
 my $mesaVersion = mesa_get::getMESAVersion();
 my $numericVersion = mesa_get::getMESANumericVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Test:    40111\n";
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
 $diff += x_40111_0($logLevel, $fileName);
 if ($diff == 0) {
  $diff += x_40111_1($logLevel, $fileName);
 }


 appendResult();
 close LOG;
 $diff = mesa_evaluate::readErrorCount($logLevel, "40111/grade_40111.txt");

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("40111/grade_40111.txt", "40111/mir_mesa_40111.xml",
        $logLevel, "40111", "CONTENT_CREATOR", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 40111/grade_40111.txt and 40111/mir_mesa_40111.xml\n";
}

print "If you are submitting a result file to Kudu, submit 40111/mir_mesa_40111.xml\n\n";

