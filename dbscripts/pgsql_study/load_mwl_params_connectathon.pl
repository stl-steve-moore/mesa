#!/usr/local/bin/perl -w

# Cleans out the ordfil database and inserts schedules

use Env;
use Cwd;

$DATABASE = "ordfil";
$spsindex = 1;
%procedures = (
		"P1^Procedure 1^ERL_MESA" => ["Procedure 1"],
		"P2^Procedure 2^ERL_MESA" => ["Procedure 2"],
		"P3^Procedure 3^ERL_MESA" => ["Procedure 3A", "Procedure 3B"],
		"P4^Procedure 4^ERL_MESA" => ["Procedure 4A", "Procedure 4B"],
		"P5^Procedure 5^ERL_MESA" => ["Procedure 5"],
		"P6^Procedure 6^ERL_MESA" => ["Procedure 6"],
		"P7^Procedure 7^ERL_MESA" => ["Procedure 7"],
		"P8^Procedure 8^ERL_MESA" => ["Procedure 8A", "Procedure 8B"],
		"P10^Procedure 10^ERL_MESA" => ["Procedure 10"],
		"P20^Procedure 20^ERL_MESA" => ["Procedure 20"],
		"P21^Procedure 21^ERL_MESA" => ["Procedure 21"],
		"P22^Procedure 22^ERL_MESA" => ["Procedure 22"],
		"P23^Procedure 23^ERL_MESA" => ["Procedure 23"],

		"P1_CR^Procedure 1: CR^IHEY2" => ["P1: CR" ],
		"P2_CR^Procedure 2: CR^IHEY2" => ["P2A: CR", "P2B: CR" ],
		"P3_CR^Procedure 3: CR^IHEY2" => ["P3A: CR", "P3B: CR" ],
		"P4_CR^Procedure 4: CR^IHEY2" => ["P4: CR" ],

		"P1_CT^Procedure 1: CT^IHEY2" => ["P1: CT" ],
		"P2_CT^Procedure 2: CT^IHEY2" => ["P2A: CT", "P2B: CT" ],
		"P3_CT^Procedure 3: CT^IHEY2" => ["P3A: CT", "P3B: CT" ],
		"P4_CT^Procedure 4: CT^IHEY2" => ["P4: CT" ],

		"P1_DX^Procedure 1: DX^IHEY2" => ["P1: DX" ],
		"P2_DX^Procedure 2: DX^IHEY2" => ["P2A: DX", "P2B: DX" ],
		"P3_DX^Procedure 3: DX^IHEY2" => ["P3A: DX", "P3B: DX" ],
		"P4_DX^Procedure 4: DX^IHEY2" => ["P4: DX" ],

		"P1_MG^Procedure 1: MG^IHEY2" => ["P1: MG" ],
		"P2_MG^Procedure 2: MG^IHEY2" => ["P2A: MG", "P2B: MG" ],
		"P3_MG^Procedure 3: MG^IHEY2" => ["P3A: MG", "P3B: MG" ],
		"P4_MG^Procedure 4: MG^IHEY2" => ["P4: MG" ],

		"P1_MR^Procedure 1: MR^IHEY2" => ["P1: MR" ],
		"P2_MR^Procedure 2: MR^IHEY2" => ["P2A: MR", "P2B: MR" ],
		"P3_MR^Procedure 3: MR^IHEY2" => ["P3A: MR", "P3B: MR" ],
		"P4_MR^Procedure 4: MR^IHEY2" => ["P4: MR" ],

		"P1_NM^Procedure 1: NM^IHEY2" => ["P1: NM" ],
		"P2_NM^Procedure 2: NM^IHEY2" => ["P2A: NM", "P2B: NM" ],
		"P3_NM^Procedure 3: NM^IHEY2" => ["P3A: NM", "P3B: NM" ],
		"P4_NM^Procedure 4: NM^IHEY2" => ["P4: NM" ],

		"P1_US^Procedure 1: US^IHEY2" => ["P1: US" ],
		"P2_US^Procedure 2: US^IHEY2" => ["P2A: US", "P2B: US" ],
		"P3_US^Procedure 3: US^IHEY2" => ["P3A: US", "P3B: US" ],
		"P4_US^Procedure 4: US^IHEY2" => ["P4: US" ],

		"P1_XA^Procedure 1: XA^IHEY2" => ["P1: XA" ],
		"P2_XA^Procedure 2: XA^IHEY2" => ["P2A: XA", "P2B: XA" ],
		"P3_XA^Procedure 3: XA^IHEY2" => ["P3A: XA", "P3B: XA" ],
		"P4_XA^Procedure 4: XA^IHEY2" => ["P4: XA" ],
	      );
%actionitems = (
		"Procedure 1" => ["X1_A1^SP Action Item X1_A1^DSS_MESA"],
		"Procedure 2" => ["X2_A1^SP Action Item X2_A1^DSS_MESA"],
		"Procedure 3A" => ["X3A_A1^SP Action Item X3A_A1^DSS_MESA"],
		"Procedure 3B" => ["X3B_A1^SP Action Item X3B_A1^DSS_MESA"],
		"Procedure 4A" => ["X4A_A1^SP Action Item X4A_A1^DSS_MESA"],
		"Procedure 4B" => ["X4B_A1^SP Action Item X4B_A1^DSS_MESA",
				   "X4B_A2^SP Action Item X4B_A2^DSS_MESA"],
		"Procedure 5" => ["X5_A1^SP Action Item X5_A1^DSS_MESA"],
		"Procedure 6" => ["X6_A1^SP Action Item X6_A1^DSS_MESA"],
		"Procedure 7" => ["X7_A1^SP Action Item X7_A1^DSS_MESA"],
		"Procedure 8A" => ["X8A_A1^SP Action Item X8A_A1^DSS_MESA"],
		"Procedure 8B" => ["X8B_A1^SP Action Item X8B_A1^DSS_MESA"],
		"Procedure 10" => ["X10_A1^SP Action Item X10_A1^DSS_MESA"],
		"Procedure 20" => ["X20_A1^SP Action Item X20_A1^DSS_MESA"],
		"Procedure 21" => ["X21_A1^SP Action Item X21_A1^DSS_MESA"],
		"Procedure 22" => ["X22_A1^SP Action Item X22_A1^DSS_MESA"],
		"Procedure 23" => ["X23_A1^SP Action Item X23_A1^DSS_MESA"],
		"P1: CR" => ["X1_A1_CR^SP Action Item X1_A1_CR^IHEY2"],
		"P2A: CR" => ["X2A_A1_CR^SP Action Item X2A_A1_CR^IHEY2"],
		"P2B: CR" => ["X2B_A1_CR^SP Action Item X2B_A1_CR^IHEY2"],
		"P3A: CR" => ["X3A_A1_CR^SP Action Item X3A_A1_CR^IHEY2"],
		"P3B: CR" => ["X3B_A1_CR^SP Action Item X3B_A1_CR^IHEY2"],
		"P4: CR" => ["X4_A1_CR^SP Action Item X4_A1_CR^IHEY2"],
		"P1: CT" => ["X1_A1_CT^SP Action Item X1_A1_CT^IHEY2"],
		"P2A: CT" => ["X2A_A1_CT^SP Action Item X2A_A1_CT^IHEY2"],
		"P2B: CT" => ["X2B_A1_CT^SP Action Item X2B_A1_CT^IHEY2"],
		"P3A: CT" => ["X3A_A1_CT^SP Action Item X3A_A1_CT^IHEY2"],
		"P3B: CT" => ["X3B_A1_CT^SP Action Item X3B_A1_CT^IHEY2"],
		"P4: CT" => ["X4_A1_CT^SP Action Item X4_A1_CT^IHEY2"],
		"P1: DX" => ["X1_A1_DX^SP Action Item X1_A1_DX^IHEY2"],
		"P2A: DX" => ["X2A_A1_DX^SP Action Item X2A_A1_DX^IHEY2"],
		"P2B: DX" => ["X2B_A1_DX^SP Action Item X2B_A1_DX^IHEY2"],
		"P3A: DX" => ["X3A_A1_DX^SP Action Item X3A_A1_DX^IHEY2"],
		"P3B: DX" => ["X3B_A1_DX^SP Action Item X3B_A1_DX^IHEY2"],
		"P4: DX" => ["X4_A1_DX^SP Action Item X4_A1_DX^IHEY2"],
		"P1: MG" => ["X1_A1_MG^SP Action Item X1_A1_MG^IHEY2"],
		"P2A: MG" => ["X2A_A1_MG^SP Action Item X2A_A1_MG^IHEY2"],
		"P2B: MG" => ["X2B_A1_MG^SP Action Item X2B_A1_MG^IHEY2"],
		"P3A: MG" => ["X3A_A1_MG^SP Action Item X3A_A1_MG^IHEY2"],
		"P3B: MG" => ["X3B_A1_MG^SP Action Item X3B_A1_MG^IHEY2"],
		"P4: MG" => ["X4_A1_MG^SP Action Item X4_A1_MG^IHEY2"],
		"P1: MR" => ["X1_A1_MR^SP Action Item X1_A1_MR^IHEY2"],
		"P2A: MR" => ["X2A_A1_MR^SP Action Item X2A_A1_MR^IHEY2"],
		"P2B: MR" => ["X2B_A1_MR^SP Action Item X2B_A1_MR^IHEY2"],
		"P3A: MR" => ["X3A_A1_MR^SP Action Item X3A_A1_MR^IHEY2"],
		"P3B: MR" => ["X3B_A1_MR^SP Action Item X3B_A1_MR^IHEY2"],
		"P4: MR" => ["X4_A1_MR^SP Action Item X4_A1_MR^IHEY2"],
		"P1: NM" => ["X1_A1_NM^SP Action Item X1_A1_NM^IHEY2"],
		"P2A: NM" => ["X2A_A1_NM^SP Action Item X2A_A1_NM^IHEY2"],
		"P2B: NM" => ["X2B_A1_NM^SP Action Item X2B_A1_NM^IHEY2"],
		"P3A: NM" => ["X3A_A1_NM^SP Action Item X3A_A1_NM^IHEY2"],
		"P3B: NM" => ["X3B_A1_NM^SP Action Item X3B_A1_NM^IHEY2"],
		"P4: NM" => ["X4_A1_NM^SP Action Item X4_A1_NM^IHEY2"],
		"P1: US" => ["X1_A1_US^SP Action Item X1_A1_US^IHEY2"],
		"P2A: US" => ["X2A_A1_US^SP Action Item X2A_A1_US^IHEY2"],
		"P2B: US" => ["X2B_A1_US^SP Action Item X2B_A1_US^IHEY2"],
		"P3A: US" => ["X3A_A1_US^SP Action Item X3A_A1_US^IHEY2"],
		"P3B: US" => ["X3B_A1_US^SP Action Item X3B_A1_US^IHEY2"],
		"P4: US" => ["X4_A1_US^SP Action Item X4_A1_US^IHEY2"],
		"P1: XA" => ["X1_A1_XA^SP Action Item X1_A1_XA^IHEY2"],
		"P2A: XA" => ["X2A_A1_XA^SP Action Item X2A_A1_XA^IHEY2"],
		"P2B: XA" => ["X2B_A1_XA^SP Action Item X2B_A1_XA^IHEY2"],
		"P3A: XA" => ["X3A_A1_XA^SP Action Item X3A_A1_XA^IHEY2"],
		"P3B: XA" => ["X3B_A1_XA^SP Action Item X3B_A1_XA^IHEY2"],
		"P4: XA" => ["X4_A1_XA^SP Action Item X4_A1_XA^IHEY2"],
		);

`echo "delete from schedule;" | psql $DATABASE 2> /dev/null`;
`echo "delete from actionitem;" | psql $DATABASE 2> /dev/null`;

#print "Adding schedules...\n";
foreach $p ( sort keys %procedures) {
  foreach $sps (@{$procedures{$p}}) {
#    $procedureName = $sps;
    `echo "insert into schedule(uniserid,spsindex,spsdes)
                 values ('$p','$spsindex','$sps');" | psql $DATABASE 2> /dev/null`;
    foreach $item (@{$actionitems{$sps}}) {
      ($val, $mea, $des) = split("\\^", $item);
	print "Item = $item \n";
	print "Code = $val \n";
	print "Mean = $mea  \n";
	print "Des  = $des  \n";
	`echo "insert into actionitem(spsindex, codval, codmea, codschdes)
                 values ('$spsindex','$val','$mea', '$des');" | psql $DATABASE 2> /dev/null`;
      }
  $spsindex++;
  }
}
