#!/usr/local/bin/perl
#
# Clear the Image Manager tables.
#

use Env;

sub usageHelp {
  print "You need to set the environment variables\n" .
	" MESA_SQL_LOGIN \n" .
	" MESA_SQL_PASSWORD \n" .
	" MESA_SQL_SERVER_NAME \n" .
	" These are used by isql or osql as flags: -S server -Ulogin -Ppassword\n" .
	" isql / osql are command line tools that are part of SQL Server\n";
  die;

}
usageHelp() if !$MESA_SQL_LOGIN;
usageHelp() if !$MESA_SQL_PASSWORD;
usageHelp() if !$MESA_SQL_SERVER_NAME;

$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

$databaseName = $ARGV[0];

@scriptNames = ("clearpatient.sql", "clearvisit.sql", "clearstudy.sql",
		"clearseries.sql", "clearsopins.sql", "clearstoragecommit.sql",
		"clearppwf.sql");

foreach $sc (@scriptNames) {
  print "isql -E -S $MESA_SQL_SERVER_NAME -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc \n";
  print `isql -E -S $MESA_SQL_SERVER_NAME -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc`;

  if ($?) {
    print "Could not clear Image Manager tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;




