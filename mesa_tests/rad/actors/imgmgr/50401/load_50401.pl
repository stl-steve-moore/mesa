#!/usr/local/bin/perl -w

# Runs the Image Manager scripts interactively

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
#require imgmgr_workflow;
#require imgmgr_transactions;
require mesa_common;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

my $logLevel = 1;
$logLevel = $ARGV[0] if (scalar(@ARGV) > 0);

%varnames = mesa::get_config_params("imgmgr_test.cfg");
if (imgmgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imgmgr_test.cfg\n";
  exit 1;
}

$mesaImgMgrPortDICOM  = $varnames{"MESA_IMGMGR_DICOM_PT"};
#$mesaImgMgrPortHL7    = $varnames{"MESA_IMGMGR_HL7_PORT"};	# We don't need this value
#$mesaModPortDICOM     = $varnames{"MESA_MODALITY_PORT"};

$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

#$imCFindHost          = $varnames{"TEST_CFIND_HOST"};
#$imCFindPort          = $varnames{"TEST_CFIND_PORT"};
#$imCFindAE            = $varnames{"TEST_CFIND_AE"};

die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";

print `perl scripts/reset_servers.pl`;


my $status = mesa_xmit::sendCStoreDirectory(
	$logLevel, "", "$MESA_STORAGE/EYECARE/50401", "VISION1",
	$imCStoreAE, $imCStoreHost, $imCStorePort, 0);

die "Could not send object for 50401 to IM under test\n" if ($status != 0);

$status = mesa_xmit::sendCStoreDirectory(
	$logLevel, "", "$MESA_STORAGE/EYECARE/50401", "VISION1",
	"MESA-AE", "localhost", $mesaImgMgrPortDICOM, 0);

die "Could not send object for 50401 to MESA IM\n" if ($status != 0);
