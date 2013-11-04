#!/usr/local/bin/perl -w

use Env;
use lib "../../..//common/scripts";
require mesa_common;

sub check_environment {
 if (! $JAVA_HOME) {
  die "You need to define the environment variable JAVA_HOME to point to your JDK installation";
 }
 if (! -e $JAVA_HOME) {
  die "Env variable JAVA_HOME $JAVA_HOME does not point to an existing folder";
 }

 @neededfile= ("40051/schema.sch", "40051/voc.xml");
 foreach $neededfile (@neededfile) {
   unless (-e $neededfile){
    die "You need @neededfile to run this test.\n".
	 "Please make sure the file(s) exists before continuing further.\n".
	 "These files are part of the HL7 CRS release. If you do not have these as an HL7 member, contact the regional project manager for a copy.\n";
   }
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

sub x_40051_1 {
  print LOG "\nCTX: Care Record Summary 40051.1\n";
  print LOG "CTX: Evaluation using CRS Schematron\n";

  my ($logLevel, $file) = @_;

#  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN 40051/40051_schematron.xml -XSL schematron/schematron-basic.xsl -OUT 40051/40051.xsl -PARAM diagnose yes";
  my $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN 40051/schema.sch -XSL schematron/schematron-basic.xsl -OUT 40051/40051.xsl -PARAM diagnose yes";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  $x = "java -cp $MESA_TARGET/lib/xalan.jar org.apache.xalan.xslt.Process -IN $file -XSL 40051/40051.xsl -OUT 40051/schematron_40051.log";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  return 1 if $?;
  return 0;
}

sub appendResult {
  open RESULT, "40051/schematron_40051.log" or die "Could not open output file 40051/schematron_40051.log";
  print LOG "\n\nResult from schematron validation:\n";
  while (<RESULT>) {
	print LOG "$_";
  } 
  print LOG "\n";
}
# Main starts here
 die "Usage: perl 40051/eval_40051.pl <log level> FILE" if (scalar(@ARGV) < 1);
 $logLevel = $ARGV[0];
 check_environment();

 open LOG, ">40051/grade_40051.txt" or die "Could not open output file 40051/grade_40051.txt";
 my $mesaVersion = mesa_get::getMESAVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
 print LOG "CTX: $mesaVersion \n";
 print LOG "CTX: current date/time $date $timeToMinute\n";
 print LOG "CTX: Log level $logLevel\n";


 my $fileName;
 if (scalar(@ARGV) > 1) {
  $fileName = $ARGV[1];
 } else {
  $fileName = promptForFile();
 }
 
 my $diff = 0;
 $diff += x_40051_1($logLevel, $fileName);

 appendResult();

 #print LOG "\nTotal errors: $diff\n";
 #print LOG "This test does not tell you the XML errors; you need to find those yourself\n" if ($diff > 0);
 #print LOG "Check the terminal emulator to see if there are hints, or use a commercial XML tool\n" if ($diff > 0);
 #print "\n Total errors: $diff\n";
 print "This test does not tell you the XML errors; you need to find those yourself\n";
 print "Check the terminal emulator to see if there are hints, or use a commercial XML tool\n";
 print "Logs stored in 40051/grade_40051.txt\n";
 exit 0;

