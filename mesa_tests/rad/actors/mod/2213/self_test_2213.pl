#!/usr/local/bin/perl

use Env;

  my $x = "perl scripts/cine.pl 3 $MESA_STORAGE/modality/NM/patterns/2423.dcm GATED 2213/2213cine";
  print `$x`;
