#!/usr/bin/perl -w
use strict;

use DBI;  #see perldoc DBI, DBD::Pg
use Getopt::Std;

my $MESA_TARGET = "/opt/mesa";

# This convenience script populates the schedule and actionitem tables 

sub stripWhiteSpace {
  my $k;
  foreach $k(@_) {
    $k =~ s/^\s+|\s+$//g;
  }
}

sub fillDB {
# entries are of form, 
# uniserid, spsindex, spsdes, codval, codmea, codschdes
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
                
# insert into schedule(uniserid, spsindex, spsdes) values
#  ('P1^Procedure 1^ERL_MESA', 10, 'P1 10');
# insert into actionitem(spsindex, codval, codmea, codschdes) values
#  ('10', 'X1_A1', 'SP Action Item X1_A1', 'DSS_MESA');

    my $sch = $main::dbh->prepare("INSERT INTO schedule " .
            "(uniserid, spsindex, spsdes) values (?, ?, ?)");

    my $act = $main::dbh->prepare("INSERT INTO actionitem " .
            "(spsindex, codval, codmea, codschdes) values (?, ?, ?, ?)");

    foreach my $l (@entries) {
        print "Inserting $l\n";
        $l =~ s/@ /@/g;
        my ($uniserid, $spsindex, $spsdes, $codval, $codmea, $codschdes, $extra) = 
            split /@/, $l;

	die "Missing at least one component: $l\n" if (!  $codschdes);
	die "Extra component in: $l\n" if ($extra);

	stripWhiteSpace($uniserid, $spsindex, $spsdes, $codval, $codmea, $codschdes);
	print "$uniserid, $spsindex, $spsdes, $codval, $codmea, $codschdes\n";

	print "About to insert into schedule $spsindex\n";
        $sch->execute($uniserid, $spsindex, $spsdes) or die $main::dbh->errstr;
	print "About to insert into actionitem\n";
        $act->execute($spsindex, $codval, $codmea, $codschdes) or die $main::dbh->errstr;
    }

    $sch->finish() or die $main::dbh->errstr;
    $act->finish() or die $main::dbh->errstr;
}

sub clearDB {
    printf "Clearing schedule/actionitem from webof database...\n";
    $main::dbh->do("DELETE FROM schedule") or die $main::dbh->errstr;
    $main::dbh->do("DELETE FROM actionitem") or die $main::dbh->errstr;
}

sub usage {
    print "Usage: perl fillProtocolItemInfo.pl [-h] [-c] [-f filename]\n";
    print "Convenient function for filling destination table.\n";
    print " -h Prints this help message.\n";
    print " -c Clear all contents of the table (rather than filling it).\n";
    print " -f filename  File with data to insert into database.\n";
    print " 	The default filename is /opt/mesa/webmesa/ris_mall/config/protocolItemData.txt\n";
    exit;
}

use vars qw($opt_h $opt_c $opt_f $opt_x);
usage() if not getopts("hcf:x:");
usage() if $opt_h;


# Config settings
#
my $dbname = "webof";
my $config_fname = "$MESA_TARGET/webmesa/ris_mall/config/protocolItemData.txt";
$config_fname = $opt_f if $opt_f;
$config_fname = $opt_x if $opt_x;

# Connect to database
#
$main::dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", {AutoCommit=>1, RaiseError=>0}) 
        or die "Error: Couldn't open connection: ".$DBI::errstr;

if ($opt_c) {
    clearDB();
} elsif ($opt_f) {
    fillDB($config_fname);
} else {
    clearDB();
    fillDB($config_fname);
}


$main::dbh->disconnect;
exit;
