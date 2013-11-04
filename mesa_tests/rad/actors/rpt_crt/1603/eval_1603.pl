#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_crt;

sub goodbye() {
  exit 1;
}

sub getSPSStatus {
  my ($logLevel, $fileName) = @_;

  my ($x, $s) = mesa::getDICOMAttribute($logLevel, $fileName, "0040 4001");
  if ($x != 0) {
    print LOG "ERR: Cannot get SPS Status 0040 4001 from $fileName\n";
    return (1, "");
  }
  return (0, $s);
}

sub x_1603_1 {
 print LOG "CTX: Report Creator 1603.1 \n";
 print LOG "CTX: Evaluating the state of the GPWL \n";
 my $x = 0;

 my ($y, $s) = getSPSStatus($logLevel, "1603/rwl_q1/mesa/msg1_result.dcm");
 return 1 if ($y != 0);

 print LOG "CTX: SPS Status 0040 4001 initial query: $s\n" if ($logLevel >= 3);

 if ($s ne "SCHEDULED") {
  print LOG "ERR: SPS Status is <$s>, expected to be SCHEDULED\n\n";
  return 1;
 }

 print LOG "\n";
 return $x;
}

sub x_1603_2 {
 print LOG "CTX: Report Creator 1603.2 \n";
 print LOG "CTX: Evaluating the state of the GPWL after workitem claimed \n";
 my $x = 0;

 my ($y, $s) = getSPSStatus($logLevel, "1603/rwl_q2/mesa/msg1_result.dcm");
 return 1 if ($y != 0);

 print LOG "CTX: SPS Status 0040 4001 initial query: $s\n" if ($logLevel >= 3);

 if ($s ne "IN PROGRESS") {
  print LOG "ERR: SPS Status is <$s>, expected to be IN PROGRESS\n\n";
  return 1;
 }

 print LOG "\n";
 return $x;
}

sub x_1603_3 {
 print LOG "CTX: Report Creator 1603.3 \n";
 print LOG "CTX: Evaluating the state of the GPWL after workitem claimed \n";
 my $x = 0;

 my ($y, $s) = getSPSStatus($logLevel, "1603/rwl_q3/mesa/msg1_result.dcm");
 return 1 if ($y != 0);

 print LOG "CTX: SPS Status 0040 4001 initial query: $s\n" if ($logLevel >= 3);

 if ($s ne "SCHEDULED") {
  print LOG "ERR: SPS Status is <$s>, expected to be SCHEDULED\n\n";
  return 1;
 }

 print LOG "\n";
 return $x;
}


##### Main starts here

die "Usage <log level: 1-4> <AE Title of your GPPPS SCU> " if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
#$titleGPPPSSCU = $ARGV[1];

open LOG, ">1603/grade_1603.txt" or die "Could not open output file 1603/grade_1603.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

$diff += x_1603_1;
$diff += x_1603_2;
$diff += x_1603_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1603/grade_1603.txt \n";

exit $diff;
