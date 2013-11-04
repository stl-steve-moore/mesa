#!/usr/local/bin/perl
#
# Clear the Order Filler content.
# Leave the identifiers alone.
#

use Env;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearordfil.sql", "clearscheduling.sql");

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}

my $x = "$MESA_TARGET/bin/mesa_load_db $databaseName codes_of.txt";
print "$x\n";
print `$x`;
if ($?) {
  print "Could not execute $x\n";
  exit 1;
}

