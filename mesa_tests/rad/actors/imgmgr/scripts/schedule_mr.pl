#!/usr/local/bin/perl

use Env;

print `$MESA_TARGET/bin/of_schedule -t MESA_MOD -m MR -s STATION1 ordfil`;
