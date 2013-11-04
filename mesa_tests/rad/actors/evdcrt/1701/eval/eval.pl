#!/usr/local/bin/perl -w

# Runs the Evidence Creator evaluation scripts interactively
use Env;
Env::import();
use File::Copy;
use Getopt::Std;
use strict;
use lib "$MESA_ROOT/testdata/y3_actor/actors/common/scripts";
require mesa;


# find and evaluate the mpps which was sent for transactions 20 and 21
sub x_1701_1 {
    my @mpps_dirs = glob "$MESA_STORAGE/imgmgr/mpps/$main::MPPS_SCU_AE/*";
    if (scalar(@mpps_dirs) == 0) {
        die "Error: Found no MPPS data directories in " . 
            "\t$MESA_STORAGE/imgmgr/mpps/$main::MPPS_SCU_AE\n";
    } elsif (scalar(@mpps_dirs) > 1) {
        print LOG "Warning: there are multiple Study Instances for the AE Title " .
            "$main::MPPS_SCU_AE.  Newest one will be used.\n";
    }

# sort all the directories by their modification time (mtime) entry
    my ($newDirName, $newDirTime, $mtime, $f);
    $newDirTime = 0;
    foreach $f (@mpps_dirs) {
        $mtime = (stat($f))[9] or die "$!";
        if ($mtime > $newDirTime) {
            $newDirTime = $mtime;
            $newDirName = $f;
        }
    }

    my $mppsFile = "$newDirName/mpps.dcm";
    my $template = "1701/eval/1701_mpps_template.txt";
    die "MPPS file $mppsFile not found." if not -e $mppsFile;
    my $errorCount = mesa::evaluate_mpps_vs_template($mppsFile, $template);
    return $errorCount;
}

# get parameters from configuration file.
sub getParams {
    my $configFile = shift;
    my %varnames = mesa::get_config_params($configFile);
    $main::MPPS_SCU_AE = $varnames{"TEST_AE"} or die;
}

sub usage {
    print "Usage: perl eval [-h] [-c configFile] [-a AETitle] <log level: 0-4> \n";
    print "Runs the evaluation script with given verbosity level.\n";
    print " -h  Print this help message.\n";
    print " -c  The file defining server configuration (default is \"evdcrt_test.cfg\").\n";
    print " -a  Set the AE Title of the MPPS SCU, rather than reading \n" .
          "     it from configuration file.\n";
    exit;
}

# main program starts here.
use vars qw($opt_h $opt_a $opt_c);
usage() if not getopts("hc:a:");
usage() if $opt_h;

my $runningDir = "$MESA_ROOT/testdata/y3_actor/actors/evdcrt";
chdir $runningDir;

my $defaultConfigFile = "evdcrt_test.cfg";
my $configFile = $opt_c ? $opt_c : $defaultConfigFile;

$main::logLevel = shift or usage();

# set up logging in 1701/results/eval
my $outDir = "1701/results/eval";
my $outFile = "grade_1701.txt";
print "output of the evaluation will be written to $outDir/$outFile\n\n";
mesa::delete_directory($main::logLevel, $outDir);
mesa::create_directory($main::logLevel, $outDir);
open LOG, ">$outDir/$outFile" or die "$!";

# obtain the AE Title
if (not $opt_a) {
    getParams($configFile);
    print "Obtained AE Title $main::MPPS_SCU_AE from configuration file $configFile.\n"
        if $main::logLevel >= 3;
} else {
    $main::MPPS_SCU_AE = $opt_a;
    print "Obtained AE Title $main::MPPS_SCU_AE from command line parameter.\n"
        if $main::logLevel >= 3;
}

my $diff = x_1701_1;
print "Got $diff errors.  See $outDir/$outFile for details\n";

