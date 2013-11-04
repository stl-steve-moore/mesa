#!/usr/local/bin/perl -w

# Cleans out the ordfil database and inserts schedules

use Env;
use Cwd;

$DATABASE = "ordfil";
$spsindex = 1;
%procedures = (
	       "P1" => [ "Procedure 1" ],
	       "P2" => [ "Procedure 2" ],
	       "P3" => ["Procedure 3A", "Procedure 3B" ],
	       "P4" => ["Procedure 4A", "Procedure 4B" ],
	       "P5" => ["Procedure 5"],
	       "P6" => ["Procedure 6"],
	       "P7" => ["Procedure 7"],
	       "P8" => ["Procedure 8A", "Procedure 8B"],
	       "P10" => ["Procedure 10"],
	       "P20" => ["Procedure 20"],
	       "P21" => ["Procedure 21"],
	       "P22" => ["Procedure 22"],
	       "P23" => ["Procedure 23"],
	       "P101" => ["Procedure 101"],
	       "P102" => ["Procedure 102"],
	      );
%actionitems = (
		"Procedure 1" => ["X1_A1"],
		"Procedure 2" => ["X2_A1"],
		"Procedure 3A" => [ "X3A_A1"],
		"Procedure 3B" => ["X3B_A1" ],
		"Procedure 4A" => [ "X4A_A1"],
		"Procedure 4B" => ["X4B_A1", "X4B_A2" ],
		"Procedure 5" => ["X5_A1"],
		"Procedure 6" => ["X6_A1"],
		"Procedure 7" => ["X7_A1"],
		"Procedure 8A" => ["X8A_A1"],
		"Procedure 8B" => ["X8B_A1"],
		"Procedure 10" => ["X10_A1"],
		"Procedure 20" => ["X20_A1"],
		"Procedure 21" => ["X21_A1"],
		"Procedure 22" => ["X22_A1"],
		"Procedure 23" => ["X23_A1"],
		"Procedure 101" => ["X101_A1"],
		"Procedure 102" => ["X102_A1"],
		);

`echo "delete from schedule;" | psql $DATABASE 2> /dev/null`;
`echo "delete from actionitem;" | psql $DATABASE 2> /dev/null`;

#print "Adding schedules...\n";
foreach $p ( sort keys %procedures) {
  foreach $sps (@{$procedures{$p}}) {
    $procedureName = $sps;
    $procedureName =~ s/(\d)[A-Z]$/$1/;
    `echo "insert into schedule(uniserid,spsindex,spsdes)
                 values ('$p^$procedureName^ERL_MESA','$spsindex','$p $spsindex');" | psql $DATABASE 2> /dev/null`;
    foreach $item (@{$actionitems{$sps}}) {
	`echo "insert into actionitem(spsindex, codval, codmea, codschdes)
                 values ('$spsindex','$item','SP Action Item $item', 'DSS_MESA');" | psql $DATABASE 2> /dev/null`;
      }
  $spsindex++;
  }
}
