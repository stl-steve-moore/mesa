#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

sub dummy {
}

sub propose_sop_class {
  my ($logLevel, $calling, $called, $host, $port, $sopClass) = @_;
  my $x = "$MESA_TARGET/bin/open_assoc -s 1 -z -a $calling -c $called -x $sopClass $host $port";
  print LOG "CTX: ";
  print LOG `$x`;
  return 1 if $?;
  return 0;
}

# 

sub x_50405_1 {
  my ($imCStoreAE, $imCStoreHost, $imCStorePort) = @_;
  print LOG "CTX: Image Manager 50405.1 \n";
  print LOG "CTX: Evaluating Storage SOP Classes and Transfer Syntaxes accepted by IM\n";
  @sopClassList = ( "1.2.840.10008.5.1.4.1.1.6.1",	# Ultrasound
	"1.2.840.10008.5.1.4.1.1.3.1",			# Ultrasound Multi-frame
	"1.2.840.10008.5.1.4.1.1.77.1.5.1",		# Opthalmic 8 bit Photography Image Storage
	"1.2.840.10008.5.1.4.1.1.77.1.5.2",		# Opthalmic 16 bit Photography Image Storage
	"1.2.840.10008.5.1.4.1.1.88.33",		# Opthalmic 16 bit Photography Image Storage
	"1.2.840.10008.5.1.4.1.1.104.1",		# Encapsulated PDF storage
  );

  my $count = 0;
  foreach $sopClass(@sopClassList) {
    print "Proposing SOP Class: $sopClass\n";
    $count += propose_sop_class(
		$logLevel,
		"VISION1", $imCStoreAE, $imCStoreHost, $imCStorePort,
		$sopClass);
    print LOG "\n";
  }
  return $count;
}

die "Usage <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">50405/grade_50405.txt" or die "Could not open output grade file: 50405/grade_50405.txt";
$diff = 0;

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    50405\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

%varnames = mesa::get_config_params("imgmgr_test.cfg");

$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

$diff = x_50405_1($imCStoreAE, $imCStoreHost, $imCStorePort);

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

print LOG "Total errors: $diff\n";

close LOG;

open LOG, ">50405/mir_mesa_50405.xml" or die "Could not open XML output file: 50405/mir_mesa_50405.xml";

mesa_evaluate::eval_XML_start($logLevel, "50405", "IM", $version, $date);
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);

if ($logLevel != 4) {
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}
mesa_evaluate::startDetails($logLevel);

open TMP, "<50405/grade_50405.txt" or die "Could not open 50405/grade_50405.txt for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 50405/grade_50405.txt \n";
print "Submit 50405/mir_mesa_50405.xml for grading\n";


exit $diff;
