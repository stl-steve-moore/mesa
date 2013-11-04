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


sub x_1601_1 {
 print LOG "CTX: Report Creator 1601.1 \n";
 print LOG "CTX: Evaluating GPPPS \n";
 my $x = 0;

 $x = mesa::evaluate_gppps_workitem_status (
	$logLevel,
	"1601/pps/interp/mesa",			# Dir for MESA temp files
	"$MESA_STORAGE/postproc/gppps/$titleGPPPSSCU",	# Dir for report creator GPPPS
	"$MESA_STORAGE/postproc/gppps/MESA_RPTCRT",	# Dir for MESA report creator GPPPS
	"1"
	);
 print LOG "\n";
 return $x;
}


sub x_1601_2 {
 print LOG "CTX: Report Creator 1601.2 \n";
 print LOG "CTX: Evaluating the state of the GPWL after workitem released\n";
 my $x = 0;

 my ($y, $s) = getSPSStatus($logLevel, "1601/rwl_q2/mesa/msg1_result.dcm");
 return 1 if ($y != 0);

 print LOG "CTX: SPS Status 0040 4001 initial query: $s\n" if ($logLevel >= 3);

 if ($s ne "COMPLETED") {
  print LOG "ERR: SPS Status is <$s>, expected to be COMPLETED\n\n";
  return 1;
 }

 print LOG "\n";
 return $x;
}



sub read_ppsSOPUID {
  my $fname = shift(@_);

  open FILE, $fname or die "Unable to find PPS SOP UID file: $fname\n";

  $uid = <FILE>;
  return $uid;
}


##### Main starts here

die "Usage <log level: 1-4> <AE Title of your GPPPS SCU> " if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleGPPPSSCU = $ARGV[1];

open LOG, ">1601/grade_1601.txt" or die "Could not open output file 1601/grade_1601.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

$diff += x_1601_1;
$diff += x_1601_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1601/grade_1601.txt \n";

exit $diff;
