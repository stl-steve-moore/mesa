#!/usr/local/bin/perl -w

use Env;
Env::import();
use Getopt::Std;
use strict;
use lib "../common/scripts";
require mesa;


sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_1701_1 {
  print LOG "CTX: Image Manager 1701.1 \n";
  print LOG "CTX: C-Find response, Study Level query \n";

# first we need to get the output directories.  They can be found in the 1701.txt file.
  my $configFile = "../common/1701/1701.txt";

  open CONFIG, "<$configFile" or die "Cannot open $configFile: $!\n";
  while (<CONFIG>) {
      next if not /TRANSACTION\s+44/;
# TRANSACTION 44  IM ID   QUERY   1701/results/43/srUID.dcm   1701/data/44   1701/results/44
      my @fields = split /\s+/;
      my $outputDir = $fields[-1];

      $main::diff += mesa::evaluate_cfind_resp(
		$main::logLevel,
		"0020", "000D", "1701/cfind_study_mask.txt",
		"$outputDir/test",
		"$outputDir/mesa"
		);
      last;
  }
  close CONFIG;
  print LOG "\n";
}


### Main starts here

die "Usage:\n\tperl eval_1701.pl <log level: 1-4> \n" if (scalar(@ARGV) != 1);


$main::logLevel     = $ARGV[0];

my $outDir = "1701";
my $outFile = "grade_1701.txt";
print "output of the evaluation will be written to $outDir/$outFile\n\n";

open LOG, ">$outDir/$outFile" or die "Could not open output file $outDir/$outFile";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$main::diff = 0;

x_1701_1();

print LOG "\nTotal Differences: $main::diff \n";
print "\nTotal Differences: $main::diff \n";

print "Logs stored in $outDir/$outFile \n";

exit $main::diff;
