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

# End of subroutines, beginning of the main code

$x = $ENV{'MESA_OS'};
die "Env variable MESA_OS is not set; please read Installation Guide \n" if $x eq "";

%parms = imgmgr::read_config_params_hash();

$imCStoreHost = $parms{"TEST_CSTORE_HOST"};
$imCStorePort = $parms{"TEST_CSTORE_PORT"};
$imCStoreAE = $parms{"TEST_CSTORE_AE"};
$mesaCStoreHost = $parms{"MESA_IMGMGR_HOST"};
$mesaCStorePort = $parms{"MESA_IMGMGR_DICOM_PT"};
$mesaCStoreAE = $parms{"MESA_IMGMGR_AE"};

`perl scripts/reset_servers.pl`;


$series = "../disp_cons";
$deltafile = "";
store( $series, $deltafile);


# Key Image Note goes with CRTHREE^PAUL
mesa::cstore_file("../../msgs/sr/511/sr_511_cr.dcm", "", $imCStoreAE,
			$imCStoreHost, $imCStorePort);
mesa::cstore_file("../../msgs/sr/511/sr_511_cr.dcm", "", $mesaCStoreAE,
			$mesaCStoreHost, $mesaCStorePort);

# Key Image Note goes with CTFIVE^JIM
mesa::cstore_file("../../msgs/sr/512/sr_512_ct.dcm", "", $imCStoreAE,
			$imCStoreHost, $imCStorePort);
mesa::cstore_file("../../msgs/sr/512/sr_512_ct.dcm", "", $mesaCStoreAE,
			$mesaCStoreHost, $mesaCStorePort);

# Key Image Note goes with MRTHREE^STEVE
mesa::cstore_file("../../msgs/sr/513/sr_513_mr.dcm", "", $imCStoreAE,
			$imCStoreHost, $imCStorePort);
mesa::cstore_file("../../msgs/sr/513/sr_513_mr.dcm", "", $mesaCStoreAE, 
			$mesaCStoreHost, $mesaCStorePort);

goodbye;
