#!/usr/local/bin/perl
#
# Clear the Syslog tables.
#

use Env;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearsyslogentry.pgsql" );

foreach $sc (@scriptNames) {
  print "psql $databaseName < $sc \n";
  print `psql $databaseName < $sc`;

  if ($?) {
    print "Could not clear Syslog Tables tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;

