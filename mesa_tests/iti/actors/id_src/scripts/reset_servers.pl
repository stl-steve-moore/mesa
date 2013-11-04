#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use lib "scripts";
require id_src;

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

%varnames = mesa::get_config_params("id_src.cfg");
if (id_src::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in id_src.cfg\n";
  exit 1;
}

$mesaXRefPortHL7     = $varnames{"MESA_XREF_PORT_HL7"};

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaXRefPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/xref/hl7");
mesa::create_directory(1, "$MESA_STORAGE/xref/hl7");

goodbye;

