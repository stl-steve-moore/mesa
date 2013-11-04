#!/usr/local/bin/perl
#
# Clear the Queue Manager tables.
#

use Env;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearworkorders.pgsql",  "clearusers.pgsql",
		"clearlastreq.pgsql");

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear Queue Manager tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;

