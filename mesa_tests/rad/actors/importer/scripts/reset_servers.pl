#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
use lib "../../../common/scripts";
require imp;
require mesa_common;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

%varnames = mesa_get::get_config_params("imp_test.cfg");
if (imp::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in imp_test.cfg\n";
  exit 1;
}


# Order Filler
$mesaOFPortHL7= $varnames{"MESA_OF_PORT_HL7"};
$mesaOFHost   = $varnames{"MESA_OF_HOST"};
print `$MESA_TARGET/bin/kill_hl7 -e RST $mesaOFHost $mesaOFPortHL7`;
die "Could not reset MESA Order Filler" if ($?);

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

 mesa::delete_directory(1, "$MESA_STORAGE/ordfil/gppps");
 mesa::create_directory(1, "$MESA_STORAGE/ordfil/gppps");

 mesa::delete_directory(1, "$MESA_STORAGE/tmp");
 mesa::create_directory(1, "$MESA_STORAGE/tmp");

goodbye;


