#!/usr/bin/perl -w
use strict;

use DBI;  #see perldoc DBI, DBD::Pg
use Getopt::Std;

# this convenience script populates the user table with usernames and no
# passwords.
# see the table definition in $MESA_ROOT/dbscripts/pgsql/user.sql

sub fillDB {
# entries have one name per line.  Comments (#...)are ignored.
    my $fname = shift or die("Filename not passed.\n");
    open IN, "<$fname" or die "Cannot open $fname: $!\n";
    my @entries;

    while (my $line = <IN>) {
        $line =~ s/#.*$//;          # take off comments
        $line =~ s/\s+$//; # take off trailing whitespace
        $line =~ s/^\s+//; # take off leading whitespace
        next if $line eq "";
        push @entries, $line;
    }
                

    my $sth = $main::dbh->prepare("INSERT INTO user_table " .
            "(user_name) values (?)");

    foreach my $l (@entries) {
        print "Inserting $l\n";
        $sth->execute($l) or die $main::dbh->errstr;
    }

    $sth->finish() or die $main::dbh->errstr;
}

sub clearDB {
    printf "Clearing...\n";
    $main::dbh->do("DELETE FROM user_table") or die $main::dbh->errstr;
    $main::dbh->do("select setval('user_table_user_id_seq', 1, false)") 
        or die $main::dbh->errstr;
}

sub usage {
    print "Usage: perl fillUserTables.pl [-h] [-c] -f filename database\n";
    print "Convience function for filling destination table.\n";
    print " -h Prints this help message.\n";
    print " -c Clear all contents of the table (rather than filling it).\n";
    print " -f Use given filename as config file listing user names.  Required.\n";
    print " database The database which contains user_table table to be filled.\n";
    exit;
}

use vars qw($opt_h $opt_c $opt_f);
usage() if not getopts("hcf:");
usage() if $opt_h;
#usage() if not $opt_f;

# Config settings
#
my $dbname = shift or usage();
my $config_fname = $opt_f;

# Connect to database
#
$main::dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", {AutoCommit=>1, RaiseError=>0}) 
        or die "Error: Couldn't open connection: ".$DBI::errstr;

if ($opt_c) {
    clearDB();
} else {
    fillDB($config_fname);
}


$main::dbh->disconnect;
exit;
