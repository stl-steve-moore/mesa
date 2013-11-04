#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q411a", "q411b");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 411/$q.txt 411/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 411/q411a.dcm 411/results/a";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 411/q411b.dcm 411/results/b";
print `$cmd`;

