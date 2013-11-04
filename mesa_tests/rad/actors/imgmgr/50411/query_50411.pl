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

sub makeQuery {
  my $x = "$MESA_TARGET/bin/dcm_create_object -i 50411/query.txt 50411/query.dcm";
  `$x`;
  die "Could not create query: $x\n" if $?;
}

my $logLevel = 1;
$logLevel = $ARGV[0] if (scalar(@ARGV) > 0);

%varnames = mesa::get_config_params("imgmgr_test.cfg");
if (imgmgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imgmgr_test.cfg\n";
  exit 1;
}

sub makeDirectories {
  mesa_utility::delete_directory(0, "50411/test");
  mesa_utility::create_directory(0, "50411/test");
  mesa_utility::delete_directory(0, "50411/mesa");
  mesa_utility::create_directory(0, "50411/mesa");
}

sub sendQuery {
  $x = mesa_xmit::sendCFind($logLevel, "STUDY",
	"50411/query.dcm", $imCFindAE, $imCFindHost, $imCFindPort, "VISION1", "50411/test");

  die "Could not send C-Find to IM under test\n" if ($x != 0);

  $x = mesa_xmit::sendCFind($logLevel, "STUDY",
	"50411/query.dcm", $imCFindAE, "localhost", $mesaImgMgrPortDICOM, "VISION1", "50411/mesa");

  die "Could not send C-Find to MESA IM \n" if ($x != 0);
}


$mesaImgMgrPortDICOM  = $varnames{"MESA_IMGMGR_DICOM_PT"};
#$mesaImgMgrPortHL7    = $varnames{"MESA_IMGMGR_HL7_PORT"};	# We don't need this value
#$mesaModPortDICOM     = $varnames{"MESA_MODALITY_PORT"};

#$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
#$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
#$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

$imCFindHost          = $varnames{"TEST_CFIND_HOST"};
$imCFindPort          = $varnames{"TEST_CFIND_PORT"};
$imCFindAE            = $varnames{"TEST_CFIND_AE"};

die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa_get::getMESAVersion();
print "MESA Version: $version\n";
($x, $date, $timeMin) = mesa_get::getDateTime($logLevel);
die "Could not get current date/time" if ($x != 0);
print "Date/time = $date $timeMin\n";


makeQuery;
makeDirectories;
sendQuery;
