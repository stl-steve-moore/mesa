#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q406a");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 406a/$q.txt 406a/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 406a/q406a.dcm 406a/results";
print `$cmd`;


