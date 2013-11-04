#!/usr/local/bin/perl -w

use Env;
use lib "scripts";

sub build_queries {
  $cmd = "$MESA_TARGET/bin/dcm_create_object ";
  @queries = ("q401a", "q401b", "q401c", "q401d", "q401e", "q401f");

  foreach $q(@queries) {
    $x = "$cmd " . "-i 401/$q.txt 401/$q.dcm";

    print "$x\n";
    print `$x`;
    die "Could not produce query $q \n" if $?;
  } 
}

build_queries();

$cmd = "perl scripts/img_mgr_query.pl 401/q401a.dcm 401/results/a";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 401/q401b.dcm 401/results/b";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 401/q401c.dcm 401/results/c";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 401/q401d.dcm 401/results/d";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 401/q401e.dcm 401/results/e";
print `$cmd`;

$cmd = "perl scripts/img_mgr_query.pl 401/q401f.dcm 401/results/f";
print `$cmd`;

