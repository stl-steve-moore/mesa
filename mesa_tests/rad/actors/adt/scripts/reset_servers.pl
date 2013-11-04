#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use lib "scripts";
require adt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

%varnames = mesa::get_config_params("adt_test.cfg");
if (adt::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in adt_test.cfg\n";
  exit 1;
}

$mesaOrderFillerPortHL7     = $varnames{"MESA_ORD_FIL_PORT_HL7"};
$mesaOrderPlacerPortHL7     = $varnames{"MESA_ORD_PLC_PORT_HL7"};
$mesaChargeProcessorPortHL7 = $varnames{"MESA_CHG_PROC_PORT_HL7"};

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaOrderFillerPortHL7`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaOrderPlacerPortHL7`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaChargeProcessorPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/chgp/hl7");
mesa::create_directory(1, "$MESA_STORAGE/chgp/hl7");

goodbye;

