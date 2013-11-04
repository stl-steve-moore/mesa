#!/usr/local/bin/perl
#
# Clear the Order Filler content.
# Leave the identifiers alone.
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


$x = scalar(@ARGV);
if ($x == 0) {
  print "Usage: <Database Name> \n";
  exit 1;
}

usageHelp() if !$MESA_SQL_LOGIN;
usageHelp() if !$MESA_SQL_PASSWORD;
usageHelp() if !$MESA_SQL_SERVER_NAME;

$databaseName = $ARGV[0];

@scriptNames = ("clearpatient.sql", "clearvisit.sql", "clearplacerorder.sql",
		"clearfillerorder.sql", "clearmwl.sql", "clearordr.sql",
		"clearppwf.sql", "load_codes_of.sql");

foreach $sc (@scriptNames) {
  my $x = "isql -E -S $MESA_SQL_SERVER_NAME -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc";
  print "$x\n";
  print `$x`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}


