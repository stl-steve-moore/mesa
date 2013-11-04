#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

%varnames = mesa::get_config_params("ordfil_test.cfg");
if (ordfil::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in ordfil_test.cfg\n";
  exit 1;
}


# Order Placer
$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaOrderPlacerPortHL7`;
die "Could not reset MESA Order Placer" if ($?);

# Charge Processor
$mesaChargeProcessorPortHL7 = $varnames{"MESA_CHG_PRC_PORT_HL7"};
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaChargeProcessorPortHL7`;
die "Could not reset MESA Charge Processor" if ($?);

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

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;

chdir ($dir);

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/mpps");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/ppwf");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/ppwf");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/instances");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/instances");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/hl7");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/hl7");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/commit");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/commit");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/queries");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/queries");

 mesa::delete_directory(1, "$MESA_STORAGE/ordfil/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/ordfil/mpps");

goodbye;


