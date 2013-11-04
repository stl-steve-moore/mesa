#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("r1404a");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 1404/$q.txt 1404/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

# End of subroutines, beginning of the main code

build_queries();

print `perl 1404/clearWS.pl`;

print `perl 1404/img_mgr_move.pl 1404/r1404a.dcm`;


goodbye;

