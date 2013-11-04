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

@scriptNames = ("clearpatient.sql", "clearvisit.sql", "clearplacerorder.sql",
		"clearfillerorder.sql", "clearmwl.sql", "clearordr.sql",
		"clearppwf.sql", "load_codes_of.sql");

foreach $sc (@scriptNames) {
  print "isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc \n";
  print `isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}


