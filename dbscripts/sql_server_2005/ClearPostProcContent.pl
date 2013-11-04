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

@scriptNames = ("clearppwf.sql");

foreach $sc (@scriptNames) {
  print "osql -E -S $MESA_SQL_SERVER_NAME -d $databaseName < sqlfiles\\$sc \n";
  print `osql -E -S $MESA_SQL_SERVER_NAME -d $databaseName < sqlfiles\\$sc`;

  if ($?) {
    print "Could not clear Post Processing content ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;




