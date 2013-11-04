#!/usr/local/bin/perl -w

# Send Evidence Documents to the image manager.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

sub store {
    my $series = shift( @_ );
    my $delta = shift( @_ );
    mesa::store_images_absolute_path($series, $delta, "MESA_MOD", $main::imCStoreAE, 
        $main::imCStoreHost, $main::imCStorePort, 0);
# changing 1 -> 0 allows pixel data to be stored.
    mesa::store_images_absolute_path($series, $delta, "MESA_MOD", $main::mesaCStoreAE, 
        $main::mesaCStoreHost, $main::mesaCStorePort, 0);
}

%parms = imgmgr::read_config_params_hash();

$imCStoreHost = $parms{"TEST_CSTORE_HOST"};
$imCStorePort = $parms{"TEST_CSTORE_PORT"};
$imCStoreAE = $parms{"TEST_CSTORE_AE"};
$mesaCStoreHost = $parms{"MESA_IMGMGR_HOST"};
$mesaCStorePort = $parms{"MESA_IMGMGR_DICOM_PT"};
$mesaCStoreAE = $parms{"MESA_IMGMGR_AE"};

# Clear the MESA servers to get ready for new data.
`perl scripts/reset_servers.pl`;


#------------------------------------------------------------------
# currently contains one mamography CAD report.

$series = "../../msgs/sr/1402";
$deltafile = "";
#print "imCStoreHost = $imCStoreHost\n";
store( $series, $deltafile);
#------------------------------------------------------------------

