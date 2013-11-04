#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
require ordfil;
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

%varnames = mesa::get_config_params("ordfil_secure.cfg");
if (ordfil::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in ordfil_secure.cfg\n";
  exit 1;
}

$mesaOrderPlacerPortHL7 = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaOrderFillerPortHL7 = $varnames{"MESA_ORD_FIL_PORT_HL7"};
$mesaIMPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};

my $C = "$MESA_TARGET/runtime/certificates/test_sys_1.cert.pem";
my $K = "$MESA_TARGET/runtime/certificates/test_sys_1.key.pem";
my $P = "$MESA_TARGET/runtime/certificates/mesa_list.cert";
my $R = "$MESA_TARGET/runtime/certificates/randoms.dat";

# Order Placer and IM are running with MESA certificates.
# Reset by sending reset message as a "test system".
$x = "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST " .
     " localhost $mesaOrderPlacerPortHL7";
print `$x`;

$x = "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST " .
     " localhost $mesaIMPortHL7";
print `$x`;

$C = "$MESA_TARGET/runtime/certificates/mesa_1.cert.pem";
$K = "$MESA_TARGET/runtime/certificates/mesa_1.key.pem";
$P = "$MESA_TARGET/runtime/certificates/test_list.cert";
$R = "$MESA_TARGET/runtime/certificates/randoms.dat";

# The Order Filler is using the certificates for the system under test.
# Reset by sending a message from a MESA system.
$x = "$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R -e RST " .
     "localhost $mesaOrderFillerPortHL7";
print `$x`;

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Order Filler database \n";
`perl ClearOrdFilContent.pl ordfil`;
#print "Clearing Post Processing database \n";
#`perl ClearPostProcContent.pl ordfil`;

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


