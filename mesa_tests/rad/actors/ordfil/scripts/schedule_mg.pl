#!/usr/local/bin/perl

use Env;

print `$MESA_TARGET/bin/of_schedule -t MODALITY1 -m MG -s STATION1 ordfil`;
