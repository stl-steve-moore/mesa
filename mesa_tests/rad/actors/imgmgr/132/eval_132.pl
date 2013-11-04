#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

sub dummy {}

# Examine the MPPS messages forwarded by the Image Manager

#die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

print "Image Manager test 132 has no grading associated with it.\n";
print "For this test, you just need to make sure you can work through\n";
print "the transactions.\n";
print "Enter a note in Kudu that you have completed this test\n";

exit 0;
