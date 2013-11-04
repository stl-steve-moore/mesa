#!/usr/local/bin/perl -w

# Create CT images for HIMSS 2004 demonstration

use Env;
use File::Copy;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub produce_CT_data {
  my ($mod, $modAE, $stationName, $patID, $accNumber, $mwlAE, $mwlHost, $mwlPort) = @_;

  $x = "perl scripts/produce_scheduled_images.pl $mod $modAE " .
	" $patID 67632007 TCT $mwlAE $mwlHost $mwlPort 18-5002 18-5002 CT/CT1/CT1S2 $accNumber";
  print "$x \n";

  print `$x`;
  die "Could not get MWL or produce CT data.\n" if ($?);
}

# ======================================
# Main starts here

die "Usage: <pat ID> <acc Number> <MWL AE> <MWL Host> <MWL Port>\n" if (scalar(@ARGV) != 5);

($patID, $accNumber, $mwlAE, $mwlHost, $mwlPort) = @ARGV;

produce_CT_data("CT", "MESACT", "CTSTATION", $patID, $accNumber, $mwlAE, $mwlHost, $mwlPort);

goodbye;
