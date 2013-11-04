#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_make_object ";
  @queries = ("q406b");

  foreach $q(@queries) {
    $x = "$cmd " . "406b/$q.dcm < 406b/$q.txt";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 406b/q406b.dcm 406b/results";
print `$cmd`;


