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

$x = "psql ordfil < load_id_of.pgsql ";
print "$x\n";
print `$x`;

$x = "psql ordfil < load_codes_of.pgsql ";
print "$x\n";
print `$x`;
