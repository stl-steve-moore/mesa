#!/usr/local/bin/perl -w

use Env;
use lib "../common/scripts";
require mesa;

sub promptForFile()
{
  print "Please enter full path to document \n" .
        " --> ";
  $response = <STDIN>;
  chomp $response;
  exit(1) if ($response eq "");
  return $response;
}

sub x_12501_1 {
  print LOG "CTX: XDS-MS 12501.1\n";
  print LOG "CTX: Evaluate for well formed XML\n";

  my ($logLevel, $file) = @_;

  my $x = "$MESA_TARGET/bin/mesa_xml_eval -s \"\" -l $logLevel $file";
  print LOG "CTX: $x\n" if ($logLevel >= 3);
  print LOG `$x`;

  return 1 if $?;
  return 0;
}


# Main starts here

 open LOG, ">12501/grade_12501.txt" or die "Could not open output file 12501/grade_12501.txt";
 $mesaVersion = mesa::getMESAVersion();
 print LOG "CTX: $mesaVersion \n";

 die "Usage: perl 12501/eval_12501.pl <log level> FILE" if (scalar(@ARGV) < 1);
 my $fileName;
 if (scalar(@ARGV) > 1) {
  $fileName = $ARGV[1];
 } else {
  $fileName = promptForFile();
 }
 $logLevel = $ARGV[0];
 
 my $diff = 0;
 $diff += x_12501_1($logLevel, $fileName);

 print LOG "\nTotal errors: $diff\n";
 print LOG "This test does not tell you the XML errors; you need to find those yourself\n" if ($diff > 0);
 print LOG "Check the terminal emulator to see if there are hints, or use a commercial XML tool\n" if ($diff > 0);
 print "\n Total errors: $diff\n";
 print "Logs stored in 12501/grade_12501.txt\n";
 exit 0;

