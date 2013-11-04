#!/usr/local/bin/perl

use Env;

print `$MESA_TARGET/bin/of_schedule -t MODALITY1 -m MR -s STATION1 ordfil`;
