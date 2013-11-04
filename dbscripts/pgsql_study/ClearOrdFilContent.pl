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

@scriptNames = ("clearpsview.pgsql", "clearvisit.pgsql",
		"clearplacerorder.pgsql", "clearfillerorder.pgsql",
		"clearmwl.pgsql", "clearordr.pgsql");

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}

