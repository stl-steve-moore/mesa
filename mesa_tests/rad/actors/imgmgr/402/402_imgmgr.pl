#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q402a", "q402b");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 402/$q.txt 402/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 402/q402a.dcm 402/results/a";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 402/q402b.dcm 402/results/b";
print `$cmd`;

