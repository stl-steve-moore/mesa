#!/usr/local/bin/perl -w

# Runs the Image Manager test 20725

use Env;
use lib "../../../rad/actors/imgmgr/scripts";
use lib "../../../common/scripts";

require imgmgr;
require mesa_common;


$SIG{INT} = \&goodbye;

sub goodbye {
 return 0;
}

sub x_20725_1 {
  my @sopClasses = (
	"1.2.840.10008.5.1.4.1.1.9.1.1",	# 12-Lead ECG
	"1.2.840.10008.5.1.4.1.1.9.1.2",	# ECG
	"1.2.840.10008.5.1.4.1.1.88.22",	# Enhanced SR
	"1.2.840.10008.5.1.4.1.1.88.33",	# Comprehensive SR
	"1.2.840.10008.5.1.4.1.1.88.40",	# Procedure Log Storage
	"1.2.840.10008.5.1.4.1.1.104.1",	# Encapsulated PDF
  );	

  my $rejected = 0;
  foreach $s(@sopClasses) {
    print LOG "CTX: Testing storage SOP Class: $s\n" if ($logLevel >= 3);
    my $x = "$MESA_TARGET/bin/open_assoc -s 0 -a MESA -c $imCStoreAE -x $s -z $imCStoreHost $imCStorePort";
    print "$x\n" if ($logLevel >= 3);
    print `$x`;
    if ($?) {
      print LOG "ERR: Server rejects $s\n";
      $rejected += 1;
    }
  }

  return $rejected;
}


# Main starts here

die "Usage <log level>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

%varnames = mesa::get_config_params("imgmgr_test.cfg");

$imCStoreHost         = $varnames{"TEST_CSTORE_HOST"};
$imCStorePort         = $varnames{"TEST_CSTORE_PORT"};
$imCStoreAE           = $varnames{"TEST_CSTORE_AE"};

open LOG, ">20725/grade_20725.txt" or die "Could not open output file: 20725/grade_20725.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";

my $diff = 0;
$diff = x_20725_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20725/grade_20725.txt \n";

exit $diff;

