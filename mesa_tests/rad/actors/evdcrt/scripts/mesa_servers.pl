#!/usr/bin/perl -w
use strict;

# allow the script to be started from anywhere; change to the running directory
use Env;
Env::import();
#my $runningDir = "$MESA_ROOT/testdata/y3_actor/actors/evdcrt";
#chdir $runningDir;

use Cwd;
use lib "../common/scripts";
require mesa;
use File::Copy;
use Getopt::Std;

sub goodbye { }

use vars qw($opt_h $opt_l $opt_c);
usage() if not getopts("hl:c:");
usage() if $opt_h;

my $logLevel = $opt_l ? $opt_l : 1;
my $configFile = $opt_c ? $opt_c : "evdcrt_test.cfg";
my $mode = shift or usage();
$mode =~ /start|stop|reset/i or usage();

my %params = mesa::get_config_params($configFile);

my $BIN = "$MESA_TARGET/bin";

# Servers Used:
#
# Order Filler DICOM
# Order Filler HL7
# Image Manager DICOM
# Evidence Creator Workstation
# Modality DCMPS (for Storage Commit response)

# Given commands will be executed in shell
my @start_commands = split "\n", <<START;
$BIN/of_dcmps -l $logLevel $params{MESA_OF_DICOM_PORT}
$BIN/hl7_rcvr -l $logLevel -M OF -a -z ordfil $params{MESA_OF_HL7_PORT}
$BIN/ds_dcm -l $logLevel -r $params{MESA_IMGMGR_DICOM_PT} $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg
$BIN/ds_dcm -l $logLevel -r $params{MESA_EC_DICOM_PORT} $MESA_TARGET/runtime/wkstation/ds_dcm_gsps.cfg 
$BIN/mod_dcmps -l $logLevel $params{MESA_MODALITY_PORT}
START

my @stop_commands = split "\n", <<STOP;
$BIN/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $params{MESA_OF_DICOM_PORT}
$BIN/kill_hl7 localhost $params{MESA_OF_HL7_PORT}
$BIN/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $params{MESA_IMGMGR_DICOM_PT}
$BIN/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $params{MESA_EC_DICOM_PORT}
$BIN/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $params{MESA_MODALITY_PORT}
STOP

my @reset_commands = split "\n", <<RESET;
$BIN/kill_hl7 -e RST "localhost" $params{MESA_OF_HL7_PORT}
perl ClearOrdFilContent.pl ordfil
perl ClearImgMgrTables.pl imgmgr
perl ./load_apps.pl imgmgr
perl ClearSyslogTables.pl syslog
RESET

my @reset_dirs = split "\n", <<RESET_DIRS;
$MESA_STORAGE/imgmgr/mpps
$MESA_STORAGE/imgmgr/instances
$MESA_STORAGE/imgmgr/commit
$MESA_STORAGE/imgmgr/queries
$MESA_STORAGE/ordfil/mpps
RESET_DIRS

if ($mode =~ /start/i) {
    doStart();
} elsif ($mode =~ /stop/i) {
    doStop();
} elsif ($mode =~ /reset/i) {
    doReset();
}

sub doStart {
    my $c;
    unlink glob("$MESA_STORAGE/ordfil/*hl7");
    unlink "$MESA_TARGET/logs/of_hl7ps.log" if -e "$MESA_TARGET/logs/of_hl7ps.log";

    foreach $c (@start_commands) {
        runBackground($c);
    }
}

sub doStop {
    my $c;
    foreach $c (@stop_commands) {
# do an eval to continue in case of error (eg. stopping a stopped server)
        eval {
            runForeground($c);
        }
    }
}

sub doReset {
    my $c;
    my $dir = cwd();
    chdir ("$MESA_TARGET/db");

    foreach $c (@reset_commands) {
        runForeground($c);
    }
    chdir ($dir);

    foreach $c (@reset_dirs) {
        resetDirectory($c);
    }
}

sub runBackground {
    my $command = shift;

    if ($MESA_OS eq "WINDOWS_NT") {
        $command =~ s(\/)(\\);
        # fork is implemented starting with ActivePerl 5.6, apparently.
        win_exec($command);
    } else {
        fork_exec($command);
    }
}

sub runForeground {
    my $command = shift;
    if ($MESA_OS eq "WINDOWS_NT") {
        $command =~ s(\/)(\\);
    }
    print "executing: \n$command\n" if $logLevel >= 3;
    system $command; # do system, since `backticks` have unnecessary 
                     # overhead if not collecting output
    die "Error executing:\n$command\n" if $?;
}

sub win_exec {
    my $command = shift;
    print "executing: \n$command\n" if $logLevel >= 3;
    system "start $command";
}

sub fork_exec {
    my $command = shift;

    if (!defined(my $child_pid = fork())) {
        die "cannot fork: $!\n";
    } elsif (not $child_pid) {
        # this is the child 
        print "executing: \n$command\n" if $logLevel >= 3;
        exec $command;
    } else {
        return;
    }
}

sub resetDirectory {
    my $dir = shift;
    if ($MESA_OS eq "WINDOWS_NT") {
        $dir =~ s(\/)(//);
    }
    print "Cleaning directory $dir\n" if $logLevel >= 3;
    mesa::delete_directory(1, $dir);
    mesa::create_directory(1, $dir);
}

sub usage {
    print "Usage: mesa_servers [-h] [-l logLevel] [-c configFile] start|stop|reset\n";
    print "Starts, stops or resets the mesa servers.\n";
    print " -h Prints this help message\n";
    print " -l Log level.  1 is least verbose, 4 is most.\n";
    print " -c The file defining server configuration (default is \"evdcrt_test.cfg\").\n";
    exit;
}

