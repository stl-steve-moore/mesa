#!/usr/local/bin/perl
#
# Load the Order Filler tables with identifiers.
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

print "isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d ordfil < load_id_of.sql \n";
print `isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d ordfil < load_id_of.sql`;

print "isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d ordfil < load_codes_of.sql \n";
print `isql -U$MESA_SQL_LOGIN -P$MESA_SQL_PASSWORD -d ordfil < load_codes_of.sql`;
