#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye() {
    print "Exiting...\n";
    exit 1;
}

sub fail {
    report( "\nTest 405 failed\n\n");
    report( "Exiting...\n");
    exit 1;
}

sub report {
    my $msg = shift(@_);
    print "$msg\n";
    print REPORT "$msg\n";
}

# Start the Main script

$outfile = "405/grade_405.txt";
open REPORT, ">$outfile" or die "Can't open $outfile\n";
$verbose = grep /^-v/, @ARGV;

%parms = imgmgr::read_config_params_hash();

$imCommitHost = $parms{"TEST_COMMIT_HOST"};
$imCommitPort = $parms{"TEST_COMMIT_PORT"};
$imCommitAE = $parms{"TEST_COMMIT_AE"};
$msModalityAE = $parms{"MESA_MODALITY_AE"};

# for testing, point the connection to the MESA IMGMGR.
# $imCommitHost = $parms{"MESA_IMGMGR_HOST"};
# $imCommitPort = $parms{"MESA_IMGMGR_DICOM_PT"};
# $imCommitAE = $parms{"MESA_IMGMGR_AE"};

report("\nAssociation negotiation tests.\n\n");

$cmd = "$MESA_TARGET/bin/sc_scu_association ";
$cmd .= " -v " if $verbose;
$cmd .= " -a $msModalityAE -c $imCommitAE $imCommitHost $imCommitPort";

report( "$cmd\n");
print REPORT `$cmd`;
if( $? != 0) {
    report( "Association negotiation tests failed.\n");
    print "Results in 405/grade_405.txt \n";
    fail();
}
report( "Association negotiation tests passed.\n");
print "Results in 405/grade_405.txt \n";

