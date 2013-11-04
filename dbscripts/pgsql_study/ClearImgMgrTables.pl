#!/usr/local/bin/perl
#
# Clear the Image Manager tables.
#

use Env;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearvisit.pgsql",
		"clearpsview.pgsql", "clearseries.pgsql",
		"clearsopins.pgsql", "clearstoragecommit.pgsql");

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear Image Manager tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;

