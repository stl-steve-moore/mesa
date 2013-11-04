#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use lib "scripts";
require pds_pam;

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

%varnames = mesa::get_config_params("pd_source.cfg");
if (pds_pam::test_var_names(%varnames) != 0) {
  print "Some problem with the variables in pd_source.cfg\n";
  exit 1;
}

$mesaPdcPamPortHL7     = $varnames{"MESA_PDC_PAM_PORT_HL7"};

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $mesaPdcPamPortHL7`;

mesa::delete_directory(1, "$MESA_STORAGE/ordfil/hl7");
mesa::create_directory(1, "$MESA_STORAGE/ordfil/hl7");

goodbye;

