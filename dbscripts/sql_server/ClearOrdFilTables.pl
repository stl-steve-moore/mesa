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
  print "isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc \n";
  print `isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d $databaseName < $sc`;

  if ($?) {
    print "Could not clear Order Filler tables ($databaseName $sc) \n";
    exit 1;
  }
}

exit 0;


