#!/bin/perl


  if (scalar(@ARGV) != 1) {
    print "Usage: perl create_db.pl server_name\n";
    print " Server name might be something like .\\sqlexpress\n";
    exit 1;
  }

  if (! -e "create_db.sql") {
    print "The file create_db.sql does not exist.\n";
    print "Did you run generate_create_scripts.pl?\n";
    exit 1;
  }

  my $x = "osql -S $ARGV[0] -i create_db.sql -E";
  print "$x\n";
  print `$x`;
