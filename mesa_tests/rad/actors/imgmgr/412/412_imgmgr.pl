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
  @queries = ("r412a", "r412b");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 412/$q.txt 412/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

# End of subroutines, beginning of the main code

$logLevel = 4;
die "MESA Environment Problem" if (mesa::testMESAEnvironment($logLevel) != 0);
my $version = mesa::getMESAVersion();
print "MESA Version: $version\n";


build_queries();

print `perl 412/clearWS.pl`;

print `perl 412/img_mgr_move.pl 412/r412a.dcm`;

print `perl 412/img_mgr_move.pl 412/r412b.dcm`;


goodbye;

