#!/usr/local/bin/perl -w

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
    mesa::store_images($series, $delta, "MESA_MOD", $main::imCStoreAE, 
        $main::imCStoreHost, $main::imCStorePort, 0);
    mesa::store_images($series, $delta, "MESA_MOD", $main::mesaCStoreAE, 
        $main::mesaCStoreHost, $main::mesaCStorePort, 1);
}

%parms = imgmgr::read_config_params_hash();

$imCStoreHost = $parms{"TEST_CSTORE_HOST"};
$imCStorePort = $parms{"TEST_CSTORE_PORT"};
$imCStoreAE = $parms{"TEST_CSTORE_AE"};
$mesaCStoreHost = $parms{"MESA_IMGMGR_HOST"};
$mesaCStorePort = $parms{"MESA_IMGMGR_DICOM_PT"};
$mesaCStoreAE = $parms{"MESA_IMGMGR_AE"};


$series = "Px1";
$deltafile = "405/px1.del";
store( $series, $deltafile);

$series = "Px2";
$deltafile = "405/px2.del";
store( $series, $deltafile);

$series = "Px6";
$deltafile = "405/px6.del";
store( $series, $deltafile);

$series = "Px7";
$deltafile = "405/px7.del";
store( $series, $deltafile);

