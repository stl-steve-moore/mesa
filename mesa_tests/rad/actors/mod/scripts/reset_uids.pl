#!/usr/local/bin/perl -w

# Cleans out the ordfil database and resets identifiers.

use Env;
use Cwd;

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


$dir = cwd();
chdir("$MESA_TARGET/db");

print "Clearing out ordfil database and adding schedules...\n";
print `perl ClearOrdFilContent.pl ordfil`;

#print "Loading identifiers...\n";
print `perl LoadOrdFilTables.pl ordfil`;

chdir($dir);
