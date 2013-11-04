#!/usr/local/bin/perl -w

# Runs the Image Manager exam interactively.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";
  exit 1;
}

sub fail {
    report( "\nc405a.pl failed.");
    report( "Exiting\n");
    exit 1;
}

sub report {
    my $msg = shift(@_);
    print "$msg\n";
    print REPORT "$msg\n";
}

sub send_storage_commit_events {
  my $procedure = shift(@_);

  $naction = "$MESA_TARGET/bin/naction"
           . " -a $modAE"
           . " -c $imCommitAE"
           . " $imCommitHost $imCommitPort commit ";

  $nevent = "$MESA_TARGET/bin/nevent -a MESA localhost $modPort commit ";

#  foreach $procedure(@_) {
    report( "$procedure \n");

    $nactionExec = "$naction $MESA_STORAGE/$procedure/sc.xxx"
        . " 1.2.840.10008.1.20.1.1";

    if( $MESA_OS eq "WINDOWS_NT") {
        $nactionExec =~ s(/)(\\)g;
    }
    report( "$nactionExec \n");
    print REPORT `$nactionExec`;

    if ($?) {
      report( "Could not send N-Action Request\n");
      goodbye;
    }

    $neventExec = "$nevent $MESA_STORAGE/$procedure/sc.xxx"
        . " 1.2.840.10008.1.20.1.1";

    if( $MESA_OS eq "WINDOWS_NT") {
        $neventExec =~ s(/)(\\)g;
    }
    report( "$neventExec \n");
    print REPORT `$neventExec`;

    if ($?) {
      report( "Could not send N-Event Copy\n");
      goodbye;
    }
#  }
}

# End of subroutines, beginning of the main code

$outfile = "405/commit.txt";
open REPORT, ">$outfile" or die "Can't open $outfile\n";

%parms = imgmgr::read_config_params_hash();

$imCommitHost = $parms{"TEST_COMMIT_HOST"};
$imCommitPort = $parms{"TEST_COMMIT_PORT"};
$imCommitAE= $parms{"TEST_COMMIT_AE"};

#$modHost= $parms{"MESA_MODALITY_HOST"};
$modHost= `hostname`; chomp $modHost;
$modPort= $parms{"MESA_MODALITY_PORT"};
$modAE= $parms{"MESA_MODALITY_AE"};

report( "MESA will now send storage commitment events to your Image Manager.\n");
report( "    Your parameters are:");
report( "      Host:    $imCommitHost");
report( "      Port:    $imCommitPort");
report( "      AETitle: $imCommitAE ");
report( "");
report( "You should be sending N-Event reports to the modality at:");
report( "   Host:    $modHost");
report( "   Port:    $modPort");
report( "   AETitle: $modAE ");

send_storage_commit_events("modality/Px1");
send_storage_commit_events("modality/Px2");
send_storage_commit_events("modality/Px6");
send_storage_commit_events("modality/Px7");

# for testing, copy the sc response of the mesa image manager to the place
# that the mesa modality would have put it.  Avoids having to futz with the
# default set up of the mesa imgmgr ds_dcm.
#`cp -r d:/mesa/storage/imgmgr/commit/MESA_MOD d:/mesa/storage/modality/st_comm`;

