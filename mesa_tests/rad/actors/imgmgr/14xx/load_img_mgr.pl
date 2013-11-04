#!/usr/local/bin/perl -w

# Send 1 study to the Image Manager for 14xx series tests.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

sub store_file {
    my $fileName= shift( @_ );
    my $delta = shift( @_ );
    mesa::cstore_file ($fileName, $delta, $main::imCStoreAE, 
        $main::imCStoreHost, $main::imCStorePort);
    mesa::cstore_file ($fileName, $delta, $main::mesaCStoreAE, 
        $main::mesaCStoreHost, $main::mesaCStorePort);
}

%parms = imgmgr::read_config_params_hash();

$imCStoreHost = $parms{"TEST_CSTORE_HOST"};
$imCStorePort = $parms{"TEST_CSTORE_PORT"};
$imCStoreAE = $parms{"TEST_CSTORE_AE"};
$mesaCStoreHost = $parms{"MESA_IMGMGR_HOST"};
$mesaCStorePort = $parms{"MESA_IMGMGR_DICOM_PT"};
$mesaCStoreAE = $parms{"MESA_IMGMGR_AE"};

#------------------------------------------------------------------
# send a study with two MR series.

$f = "../../msgs/sr/1402/sr_1402_1.dcm";
$deltafile = "";
print "imCStoreHost = $imCStoreHost\n";
store_file( $f, $deltafile);


