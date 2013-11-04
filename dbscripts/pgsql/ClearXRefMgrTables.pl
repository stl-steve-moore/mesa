#!/usr/local/bin/perl
#
# Clear the XRef Mgr tables
# Leave the identifiers alone.
#

use Env;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearpatient.pgsql", "clearvisit.pgsql");

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear XRef Mgr tables ($databaseName $sc) \n";
    exit 1;
  }
}

