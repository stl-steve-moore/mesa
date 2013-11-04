#!/usr/local/bin/perl -w

# Query the image manager.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

%parms = imgmgr::read_config_params_hash();

$imCFindHost = $parms{"TEST_CFIND_HOST"};
$imCFindPort = $parms{"TEST_CFIND_PORT"};
$imCFindAE = $parms{"TEST_CFIND_AE"};
$msCFindHost = $parms{"MESA_IMGMGR_HOST"};
$msCFindPort = $parms{"MESA_IMGMGR_DICOM_PT"};
$msCFindAE = $parms{"MESA_IMGMGR_AE"};

if( $#ARGV != 1) {
    print "usage: $0 <query_filename> <results_dir>\n";
    goodbye();
}
$qfile = $ARGV[0];
$rdir = $ARGV[1];

# remove any old results.
mesa::delete_directory(1, "$rdir/imgmgr");
mesa::delete_directory(1, "$rdir/mesa");

use File::Path;
mkpath(["$rdir/imgmgr", "$rdir/mesa"],0,0777);

if( -e $qfile) {
    mesa::send_cfind($qfile,$imCFindAE,$imCFindHost,$imCFindPort,"$rdir/imgmgr");
    mesa::send_cfind($qfile,$msCFindAE,$msCFindHost,$msCFindPort,"$rdir/mesa");
}
else {
    print "Couldn't find query file: $qfile\n";
    goodbye();
}


