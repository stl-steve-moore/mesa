#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/imgmgr/scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager


die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

#$logLevel     = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
#$titleSC      = $ARGV[2];
#$diff = 0;

print "There is no evaluation for Image Manager test 20101.\n";
print " You just need to complete all transactions\n";

