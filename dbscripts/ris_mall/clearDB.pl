#!/usr/bin/perl -w
use strict;

use DBI;  #see perldoc DBI, DBD::Pg
use Getopt::Std;

# this convenience script clears data from the following tables in the following
# webadt: patient, and visit
# webop: patient, visit, ordr
# webof: patient, visit, ordr, mwl

sub clearWebADT {
    printf "Clearing webadt: patient table...\n";
    $main::dbh->do("DELETE FROM patient") or die $main::dbh->errstr;

    printf "Clearing webadt: visit table...\n";
    $main::dbh->do("DELETE FROM visit") or die $main::dbh->errstr;
}

sub clearWebOP {
    printf "Clearing webop: patient table...\n";
    $main::dbh->do("DELETE FROM patient") or die $main::dbh->errstr;

    printf "Clearing webop: visit table...\n";
    $main::dbh->do("DELETE FROM visit") or die $main::dbh->errstr;

    printf "Clearing webop: ordr table...\n";
    $main::dbh->do("DELETE FROM ordr") or die $main::dbh->errstr;
}

sub clearWebOF {
    printf "Clearing webof: patient table...\n";
    $main::dbh->do("DELETE FROM patient") or die $main::dbh->errstr;

    printf "Clearing webof: visit table...\n";
    $main::dbh->do("DELETE FROM visit") or die $main::dbh->errstr;

    printf "Clearing webof: ordr table...\n";
    $main::dbh->do("DELETE FROM ordr") or die $main::dbh->errstr;

    printf "Clearing webof: mwl table...\n";
    $main::dbh->do("DELETE FROM mwl") or die $main::dbh->errstr;
}

sub usage {
    print "Usage: perl clearDB.pl [-h] database\n";
    print "Convenient script for clearing ris mall database.\n";
    print " -h Prints this help message.\n";
    exit;
}

use vars qw($opt_h);
usage() if not getopts("h:");
usage() if $opt_h;
#usage() if not $opt_f;

# Config settings
#
my $dbname = shift or usage();
#my $config_fname = $opt_f;

# Connect to database
#
$main::dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", {AutoCommit=>1, RaiseError=>0}) 
        or die "Error: Couldn't open connection: ".$DBI::errstr;

if ($dbname eq "webadt") {
	clearWebADT;
} elsif ($dbname eq "webop") {
	clearWebOP;
}elsif ($dbname eq "webof") {
	clearWebOF;
}

#if ($opt_c) {
#    clearDB();
#} else {
#    fillDB($config_fname);
#}


$main::dbh->disconnect;
exit;
