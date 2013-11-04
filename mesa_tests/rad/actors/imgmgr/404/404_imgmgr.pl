#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q404a", "q404b");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 404/$q.txt 404/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}


build_queries();


$cmd = "perl scripts/img_mgr_query.pl 404/q404a.dcm 404/results/a";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 404/q404b.dcm 404/results/b";
print `$cmd`;

