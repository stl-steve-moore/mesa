#!/usr/local/bin/perl -w

# Evaluate DICOM NMI objects

use Env;
use lib "scripts";
use lib "../../../common/scripts";
use lib "../common/scripts";
use File::Find;
require mod;
require mesa_evaluate;
require mesa_dicom_eval;
require evaluate_nmi;

sub goodbye {}

sub x_2222_1 {
  print LOG "CTX: Modality Test 2222.1 \n";
  print LOG "CTX: NMI Image WHOLEBODY/General Image Type\n";
  my ($logLevel, $path, $imageType) = @_;

  ($status, $computedType) = mesa_get::getDICOMNMImageType($logLevel, $path);
  if ($status != 0) {
    print LOG "ERR: Internal error, bad status returned in x_2222_1 $status $path\n";
    return 1;
  }
  print LOG "CTX: (Computed/Expected) Image Type: ($computedType/$imageType)\n" if ($logLevel >= 3);

  my $rtnValue = 0;
  if ($computedType ne $imageType) {
    $rtnValue = 1;
    print LOG "ERR: Computed type ($computedType) does not equal expected type ($imageType) for NM Image\n";
  }
  return $rtnValue;
}

sub x_2222_2 {
  print LOG "\nCTX: Modality Test 2222.2 \n";
  print LOG "CTX: Examining tags for image of type General/WHOLEBODY\n";

  my ($level, $path, $imageType) = @_;
  print LOG "CTX: Path for composite object: $path\n" if ($level >= 3);

  my $rtnValue = 1;
  my $status = 0;
  my $computedType = "";

  $imageType = $computedType;

  $rtnValue = evaluate_nmi::eval_General_Whole_Body($level, $path);

  print LOG "\n";
  return $rtnValue;
}

sub findPathToOneImage()
{
  return "";
}

### Main starts here
die "Usage: <log level> [path] \n" if (scalar(@ARGV) < 1);

$outputLevel = $ARGV[0];
my $path = "";
if (scalar(@ARGV) == 1) {
  $path = findPathToOneImage();
} else {
  $path = $ARGV[1];
}

open LOG, ">2222/grade_2222.txt" or die "?!";
$diff = 0;
$diff += x_2222_1($outputLevel, $path, "GeneralWholeBody");
$diff += x_2222_2($outputLevel, $path, "GeneralWholeBody");

print LOG "2222: Total errors: $diff\n";
print "2222: Total errors: $diff\n";

print "Logs stored in 2222/grade_2222.txt \n";

exit $diff;

