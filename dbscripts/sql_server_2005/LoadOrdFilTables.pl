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

print "osql -E -S $MESA_SQL_SERVER_NAME -d ordfil < sqlfiles\\load_id_of.sql \n";
print `osql -E -S $MESA_SQL_SERVER_NAME -d ordfil < sqlfiles\\load_id_of.sql`;

print "osql -E -S $MESA_SQL_SERVER_NAME -d ordfil < sqlfiles\\load_codes_of.sql \n";
print `osql -E -S $MESA_SQL_SERVER_NAME -d ordfil < sqlfiles\\load_codes_of.sql`;
