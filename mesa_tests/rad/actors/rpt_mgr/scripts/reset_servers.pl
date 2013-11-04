#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

%varnames = mesa::get_config_params("rptmgr_test.cfg");
if (rpt_mgr::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in rptmgr_test.cfg\n";
  exit 1;
}

print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 3300`;

# Order Placer
$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaOrderPlacerPortHL7`;
die "Could not reset MESA Order Placer" if ($?);

# Order Filler
$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaOrderFillerPortHL7`;
die "Could not reset MESA Order Filler" if ($?);

# Image Manager
$mesaIMPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaIMPortHL7`;
die "Could not reset MESA Image Manager (HL7)" if ($?);

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Order Filler database \n";
`perl ClearOrdFilContent.pl ordfil`;

print "Clearing Image Manager database \n";
`perl ClearImgMgrTables.pl imgmgr`;

print "Clearing Report Manager database \n";
`perl ClearImgMgrTables.pl rpt_manager`;

print "Clearing Report Repository database \n";
`perl ClearImgMgrTables.pl rpt_repos`;

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;

chdir ($dir);

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/mpps");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/mpps");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/gppps");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/gppps");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/instances");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/instances");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/hl7");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/hl7");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/commit");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/commit");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/queries");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/queries");

 mesa::delete_directory("0", "$MESA_STORAGE/ordfil/mpps");
 mesa::create_directory("0", "$MESA_STORAGE/ordfil/mpps");

 mesa::delete_directory("0", "$MESA_STORAGE/rpt_manager/instances");
 mesa::create_directory("0", "$MESA_STORAGE/rpt_manager/instances");

 mesa::delete_directory("0", "$MESA_STORAGE/rpt_manager/queries");
 mesa::create_directory("0", "$MESA_STORAGE/rpt_manager/queries");

 mesa::delete_directory("0", "$MESA_STORAGE/rpt_manager/mpps");
 mesa::create_directory("0", "$MESA_STORAGE/rpt_manager/mpps");

 mesa::delete_directory("0", "$MESA_STORAGE/postproc/gppps");
 mesa::create_directory("0", "$MESA_STORAGE/postproc/gppps");

 mesa::delete_directory("0", "$MESA_STORAGE/rpt_repos/instances");
 mesa::create_directory("0", "$MESA_STORAGE/rpt_repos/instances");

 mesa::delete_directory("0", "$MESA_STORAGE/rpt_repos/queries");
 mesa::create_directory("0", "$MESA_STORAGE/rpt_repos/queries");

goodbye;


