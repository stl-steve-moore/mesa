#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q1403a");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 1403/$q.txt 1403/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}


build_queries();


$cmd = "perl scripts/img_mgr_query.pl 1403/q1403a.dcm 1403/results/a";
print `$cmd`;

