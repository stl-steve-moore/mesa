#!/usr/local/bin/perl

use Env;

die "Usage: logLevel spsLocation scheduled-AET\n" if (scalar(@ARGV) != 3);

$logLevel = $ARGV[0];
my $x = "$MESA_TARGET/bin/of_schedule -l $ARGV[1] -t $ARGV[2] -m MR -s STATION1 ordfil";
print "$x\n" if ($logLevel >= 3);

print `$x`;
exit 1 if ($?);
