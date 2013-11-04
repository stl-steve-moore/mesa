#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use lib "scripts";
require pat_encounter_consumer;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #print "Exiting...\n";

  exit 0;
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

%varnames = mesa::get_config_params("pat_encounter_consumer.cfg");
if (pat_encounter_consumer::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in pat_encounter_consumer.cfg\n";
  exit 1;
}

#$mesaPatEncounterSrcPortHL7     = $varnames{"MESA_PES_PORT_HL7"};
$mesaPatEncounterCmrPortHL7     = $varnames{"MESA_PEC_PORT_HL7"};

#print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaPatEncounterSrcPortHL7`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaPatEncounterCmrPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/ordfil/hl7");
mesa::create_directory(1, "$MESA_STORAGE/ordfil/hl7");

mesa::delete_directory(1, "$MESA_STORAGE/ordplc/hl7");
mesa::create_directory(1, "$MESA_STORAGE/ordplc/hl7");

goodbye;

