#!/usr/local/bin/perl

use Env;

die "Usage: logLevel spsLocation scheduled-AET existing-SPS-index SPS-code\n" if (scalar(@ARGV) != 5);

$logLevel = $ARGV[0];
my $x = "$MESA_TARGET/bin/mesa_mwl_add_sps -c spsindex $ARGV[3] -l $ARGV[1] -t $ARGV[2] -m XA -s STATION2 ordfil $ARGV[4]";
print "$x\n" if ($logLevel >= 3);

print `$x`;
exit 1 if ($?);
