#!/usr/local/bin/perl
#
# Clear the Order Filler tables.
#
#if ($1 == "") then
#  echo " "
#  echo Usage: "$0 <Database Name>"
#  echo " "
#  exit 1
#endif

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

print `perl ClearOrdFilContent.pl $databaseName`;


@scriptNames = ("clearactionitem.sql", "load_id_of.sql", "clearschedule.sql",
		"clearppwf.sql" );

foreach $sc (@scriptNames) {
  print "osql -E -S $MESA_SQL_SERVER_NAME -d $databaseName < sqlfiles\\$sc \n";
  print `osql -E -S $MESA_SQL_SERVER_NAME -d $databaseName < sqlfiles\\$sc`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;


