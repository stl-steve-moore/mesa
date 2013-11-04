#!/usr/local/bin/perl -w


# Self test for test 11186.

use Env;
use File::Copy;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Find hostname of this machine
$host = `hostname`; chomp $host;

my $syslogPortMESA = 4000;

$x = "$MESA_TARGET/bin/syslog_client -f 10 -s 0 localhost $syslogPortMESA ../../msgs/atna/11186.xml";

print "$x \n";
print `$x`;

goodbye;

