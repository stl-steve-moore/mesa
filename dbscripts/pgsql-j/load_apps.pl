#!/usr/local/bin/perl

if (scalar(@ARGV) != 1) {
  print "This script takes one argument: <database name> \n";
  exit 1;
}

print `psql $ARGV[0] < loaddicomapp.sql`;
