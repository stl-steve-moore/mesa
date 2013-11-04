#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

sub dummy {}

# Examine the MPPS messages forwarded by the Image Manager

sub x_134_1 {
  print LOG "CTX: Image Manager 134.1 \n";
  print LOG "CTX: Checking IAN message has been sent to Order Filler and well constructed\n";

  my $master = "$MESA_STORAGE/modality/T134/x1.dcm";
  ($x, $uid) = mesa_get::getDICOMValue($logLevel,
	"$MESA_STORAGE/modality/T134/x1.dcm", "", "0020 000D", 0);
  if ($x != 0) {
    print LOG "ERR: Could not get Study Instance UID from $master\n";
    return 1;
  }

  my @mpps = mesa_evaluate::findMPPSDirByStudyInstanceUID($logLevel, "$MESA_STORAGE/ordfil/ian/$titleImgMgrMPPS", $uid, "ian");

  my $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR: Found $count IAN MPPS directories for patient 583070 and AE title $titleImgMgrMPPS\n";
    print LOG "ERR: Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR: You should clear the MESA Image Manager and try the test again or check your AE title\n";
    return 1;
  }

  my $rtnValue = mesa::evaluate_ian_img_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T134",
#		$mpps[0],
		"$MESA_STORAGE/ordfil/ian/$titleImgMgrMPPS",
		"$titleImgMgrQR",
		);
  print LOG "\n";
  return $rtnValue;
}


die "Usage <log level: 1-4> <Img Mgr MPPS SCU AE Title> <Img Mgr AE title for Query/Retrieve in MPPS> \n" if (scalar(@ARGV) < 3);

$logLevel        = $ARGV[0];
$titleImgMgrMPPS = $ARGV[1];
$titleImgMgrQR   = $ARGV[2];
open LOG, ">134/grade_134.txt" or die "Could not open output file: 134/grade_134.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    134\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";
$diff = 0;

$diff += x_134_1;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("134/grade_134.txt", "134/mir_mesa_134.xml",
        $logLevel, "134", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 134/grade_134.txt and 134/mir_mesa_134.xml\n";
}

print "If you are submitting a result file to Kudu, submit 134/mir_mesa_134.xml\n\n";

