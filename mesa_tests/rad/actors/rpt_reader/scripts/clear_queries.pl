#!/usr/local/bin/perl -w

# Clear all queries received by Report Rerpository

use Env;
use Cwd;
use lib "scripts";
require rpt_reader;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

if ($MESA_OS eq "WINDOWS_NT") {
 rpt_reader::delete_directory("$MESA_STORAGE\\rpt_repos\\queries");
 rpt_reader::create_directory("$MESA_STORAGE\\rpt_repos\\queries");

} else {
 rpt_reader::delete_directory("$MESA_STORAGE/rpt_repos/queries");
 rpt_reader::create_directory("$MESA_STORAGE/rpt_repos/queries");

}
goodbye;

