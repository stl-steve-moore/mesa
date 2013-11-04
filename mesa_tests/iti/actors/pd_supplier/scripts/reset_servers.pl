#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require pd_supplier;

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

%varnames = mesa::get_config_params("pd_supplier.cfg");
if (pd_supplier::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in pd_supplier.cfg\n";
  exit 1;
}

$mesaPDSPortHL7     = $varnames{"MESA_PDS_PORT_HL7"};

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaPDSPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/pd_supplier/hl7");
mesa::create_directory(1, "$MESA_STORAGE/pd_supplier/hl7");

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing PDS Mgr database \n";
`perl clear_xref_tables.pl pd_supplier`;
chdir ($dir);

goodbye;

