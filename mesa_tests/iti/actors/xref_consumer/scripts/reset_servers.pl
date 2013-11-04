#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require xref_cons;

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

%varnames = mesa::get_config_params("xref_consumer.cfg");
if (xref_cons::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in xref_consumer.cfg\n";
  exit 1;
}

$mesaXRefPortHL7     = $varnames{"MESA_XREF_PORT_HL7"};

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaXRefPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/xref/hl7");
mesa::create_directory(1, "$MESA_STORAGE/xref/hl7");

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing XRef Mgr database \n";
`perl clear_xref_tables.pl xref_mgr`;
chdir ($dir);

goodbye;

