#!/usr/local/bin/perl -w

# Send 6 studies to the image manager.

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

# Clear the MESA servers to get ready for new data.
`perl scripts/reset_servers.pl`;

#------------------------------------------------------------------
# send a study with two MR series.

$series = "MR/MR1/MR1S1";
$deltafile = "40x-j/a.del";
print "imCStoreHost = $imCStoreHost\n";
store( $series, $deltafile);

$series = "MR/MR1/MR1S2";
$deltafile = "40x-j/a2.del";
store( $series, $deltafile);
#------------------------------------------------------------------


#------------------------------------------------------------------
# send a study with 2 MR series and 1 CT series.

$series = "MR/MR2/MR2S1";
$deltafile = "40x-j/b.del";
store( $series, $deltafile);
$series = "MR/MR2/MR2S2";
$deltafile = "40x-j/b2.del";
store( $series, $deltafile);
$series = "CT/CT2/CT2S1";
$deltafile = "40x-j/b3.del";
store( $series, $deltafile);
#------------------------------------------------------------------


#------------------------------------------------------------------
# send a study with 1 CT series.
$series = "CT/CT3/CT3S1";
$deltafile = "40x-j/c.del";
store( $series, $deltafile);
#------------------------------------------------------------------


#------------------------------------------------------------------
# send a study with 1 CR series.
$series = "CR/CR1/CR1S1";
$deltafile = "40x-j/d.del";
store( $series, $deltafile);
#------------------------------------------------------------------


#------------------------------------------------------------------
# send 2 studies
# study 1 has 3 series with 1 OT image each.
# study 2 has 2 series with 1 OT image each.
#$series = "../disp_cons";
#$deltafile = "40x-j/e.del";
#store( $series, $deltafile);
#------------------------------------------------------------------

