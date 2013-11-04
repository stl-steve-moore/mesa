#!/usr/bin/perl -w
use strict;

# allow the script to be started from anywhere; change to the running directory
use Env;
Env::import();

use lib "$MESA_TARGET/mesa_tests/rad/actors/common/scripts";
require mesa;
use Getopt::Std;

use vars qw($opt_h);
usage() if not getopts("h");
usage() if $opt_h;

my $mode = shift or usage();
$mode =~ /time|date|datetime/i or usage();

if ($mode =~ /^time$/i) {
    print mesa::timeDICOM() . "\n"; 
} elsif ($mode =~ /^date$/i) {
    print mesa::dateDICOM() . "\n"; 
} elsif ($mode =~ /^datetime$/i) {
    print mesa::dateDICOM() . mesa::timeDICOM() . "\n"; 
}

sub usage {
    print "Usage: getMesaInfo [-h] time|date|datetime\n";
    print "Utility function for various simple MESA scripts.\n";
    print " -h Prints this help message\n";
    print " time Returns the current DICOM-formatted time.\n";
    print " date Returns the current DICOM-formatted date.\n";
    print " datetime Returns the current DICOM-formatted Date Time (DT) string.\n";
    exit;
}

