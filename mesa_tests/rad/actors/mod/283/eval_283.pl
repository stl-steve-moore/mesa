#!/usr/local/bin/perl -w

# Evaluate DICOM Composite Objects using Agfa/Philips DVT.

use Env;
use lib "scripts";
use File::Find;
require mod;

sub goodbye {}

sub x_283_1 {
  print LOG "CTX: Modality Test 283.1 \n";
  print LOG "CTX:  DICOM Composite Object evaluation\n";

  my ($level, $path) = @_;
  print LOG "CTX: Path for composite object: $path\n" if ($level >= 3);

  # Place evaluation here. Return 0 on success, return 1 on failure
  # All output should be printed into LOG
  find(\&edits, $path);

  sub edits() {
		return unless -f;
		push @files, $File::Find::name;
	}

	foreach (sort @files) {
		$length = length($_)+53;
		for ($i=1; $i<=$length; $i++) { print LOG "#"; }
		print LOG "\n";

		local($command) = "dvtcmd -m 283/temp.ses ".$_;
		$valRes = `$command`;
		print LOG ("################# Start validating $_ #################\n"."$valRes\n");
		my @tf = split(/\\/,$_);
		my $size = @tf;
		my $temp = $tf[$size-1];
		my @temp = split(/\./,$temp);
		#my $fileName = $temp[0];
		#print LOG ("$temp");
		print LOG ("\nPlease check the following test result files\n");
		print LOG ("283/Summary_001_".$temp[0]."_".$temp[1]."_DCM_res.xml\n");
		print LOG ("283/Detail_001_".$temp[0]."_".$temp[1]."_DCM_res.xml");
		print LOG "\n\n";
  }

  my $rtnValue = 0;

  print LOG "\n";
  return $rtnValue;
}

sub setLogLevel{
	system("copy 283\\validation.ses 283\\temp.ses") && die "can not copy 283\\validation.ses to 283\\temp.ses";
	open(SESSION, ">>283\\temp.ses") || die "can not open the file.";
	if($_[0] == 1){
		print SESSION "LOG-ERROR true\n";
		print SESSION "LOG-WARNING false\n";
		print SESSION "LOG-INFO false\n";
		print SESSION "LOG-DICOM-VALIDATION-RESULTS short\n";
	}elsif($_[0] == 2){
		print SESSION "LOG-ERROR true\n";
		print SESSION "LOG-WARNING true\n";
		print SESSION "LOG-INFO false\n";
		print SESSION "LOG-DICOM-VALIDATION-RESULTS standard\n";
	}elsif($_[0] >= 3){
		print SESSION "LOG-ERROR true\n";
		print SESSION "LOG-WARNING true\n";
		print SESSION "LOG-INFO true\n";
		print SESSION "LOG-DICOM-VALIDATION-RESULTS long\n";
	}else{
		die "Incorrect log level";
	}
	print SESSION "ENDSESSION";
	close(SESSION);
}

### Main starts here

print "This script is now deprecated. You should run the DVTK tool by hand \n".
      " and submit the results of that tool. In the future, we will\n".
      " offer a web-based service for this (but not today)\n";
exit;

die "Usage: <log level> <path> \n" if (scalar(@ARGV) < 2);

$outputLevel = $ARGV[0];
$path = $ARGV[1];

setLogLevel($outputLevel);

open LOG, ">283/grade_283.txt" or die "?!";
$diff = 0;
$diff += x_283_1($outputLevel, $path);

#system("del 283\\temp.ses");
print "Logs stored in 283/grade_283.txt \n";

exit $diff;

