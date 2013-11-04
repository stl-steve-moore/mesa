#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q413a");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 413/$q.txt 413/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 413/q413a.dcm 413/results/a";
print `$cmd`;

