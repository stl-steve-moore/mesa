#!/usr/bin/perl -w
use strict;

use DBI;  #see perldoc DBI, DBD::Pg
use Getopt::Std;

my $MESA_TARGET = "/opt/mesa";

# this convenience script populates the destination tables of the webadt database
# with sample destinations.
# see the table definition in $MESA_ROOT/dbscripts/pgsql/createdestination.sql

sub fillDB {
# entries are of form, 
#      HOST|PORT|REC_FAC_NAM|REC_APP|COM_NAM|ACTOR_TYPE
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
                

    my $sth = $main::dbh->prepare("INSERT INTO hl7_destination " .
            "(hostname, port, rec_fac_nam, rec_app, com_nam, actor_type) " .
            " values (?, ?, ?, ?, ?, ?)");

    foreach my $l (@entries) {
        print "Inserting $l\n";
        $sth->execute(split /\|/, $l) or die $main::dbh->errstr;
    }

    $sth->finish() or die $main::dbh->errstr;
}

sub clearDB {
    printf "Clearing...\n";
    $main::dbh->do("DELETE FROM hl7_destination") or die $main::dbh->errstr;
    $main::dbh->do("select setval('hl7_destination_dest_id_seq', 1, false)") 
        or die $main::dbh->errstr;
}

sub usage {
    print "Usage: perl fillDestinationTables.pl [-h] [-c] [-f filename] database\n";
    print "Convience function for filling destination table.\n";
    print " -h Prints this help message.\n";
    print " -c Clear all contents of the table (rather than filling it).\n";
    print " -f Use given filename as config file instead of the default filename.\n";
	print "	   The default filename is $MESA_TARGET/webmesa/ris_mall/config/hl7_dest_DATABASE.txt.\n";
    print " database The database which contains hl7_destination table to be filled.\n";
    exit;
}

use vars qw($opt_h $opt_c $opt_f);
usage() if not getopts("hcf:");
usage() if $opt_h;

# Config settings
#
my $dbname = shift or usage();
my $config_fname = $opt_f ? $opt_f : "$MESA_TARGET/webmesa/ris_mall/config/hl7_dest_$dbname.txt";

# Connect to database
#
$main::dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", {AutoCommit=>1, RaiseError=>0}) 
        or die "Error: Couldn't open connection: ".$DBI::errstr;

if ($opt_c) {
    clearDB();
} else {
    #Clear out DB before filling in with destination data
    clearDB();
    fillDB($config_fname);
}


$main::dbh->disconnect;
exit;
