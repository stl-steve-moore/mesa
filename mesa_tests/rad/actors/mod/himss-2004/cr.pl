#!/usr/local/bin/perl -w

# Create CR images for HIMSS 2004 demonstration

use Env;
use File::Copy;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub produce_CR_data {
  my ($mod, $modAE, $stationName, $patID, $accNumber, $mwlAE, $mwlHost, $mwlPort) = @_;

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" $patID 241540006 TCR $mwlAE $mwlHost $mwlPort 18-5022 18-5022 CR/CR4/CR4S1 $accNumber";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce CR data.\n" if ($?);
}

# ======================================
# Main starts here

die "Usage: <pat ID> <acc Number> <MWL AE> <MWL Host> <MWL Port>\n" if (scalar(@ARGV) != 5);

($patID, $accNumber, $mwlAE, $mwlHost, $mwlPort) = @ARGV;

produce_CR_data("CR", "MESACR", "CRSTATION", $patID, $accNumber, $mwlAE, $mwlHost, $mwlPort);

goodbye;
