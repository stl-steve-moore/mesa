#!/usr/local/bin/perl

use Env;

if (scalar(@ARGV) != 1) {
  print "This script takes one argument: <database name> \n";
  exit 1;
}

$login = $ENV{'MESA_SQL_LOGIN'};
if ($login eq "") {
  print "Env variable MESA_SQL_LOGIN is not set. \n" .
	" Please refer to Installation Guide.\n";
  exit 1;
}
$passwd = $ENV{'MESA_SQL_PASSWORD'};
if ($login eq "") {
  print "Env variable MESA_SQL_PASSWORD is not set. \n" .
	" Please refer to Installation Guide.\n";
  exit 1;
}

$dbName = $ARGV[0];

$x = "isql -U$login -P$passwd -d$dbName < loaddicomapp.sql";
print "$x \n";
print `$x`;
die "Could not load applications into DB $dbName \n" if ($?);

