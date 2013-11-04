#!/usr/local/bin/perl -w

# Clears query files from MESA Image Manager.

use Env;
use Cwd;
use lib "scripts";
require imgdisp;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

imgdisp::delete_directory("$MESA_STORAGE/imgmgr/queries");
imgdisp::create_directory("$MESA_STORAGE/imgmgr/queries");

