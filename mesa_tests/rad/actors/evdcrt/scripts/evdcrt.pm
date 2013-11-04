#!/usr/local/bin/perl -w

# Package for Importer scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package evdcrt;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(
#);



sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"TEST_AE", "TEST_EC_HOST", "TEST_EC_PORT", "TEST_EC_AE",
	"TEST_CSTORE_SCP_HOST",  "TEST_CSTORE_SCP_PORT", "TEST_CSTORE_SCP_AE", 

#	"MESA_IMG_MGR_PORT_HL7", "MESA_IMG_MGR_PORT_DCM",
#	"MESA_IMG_MGR_AE_MPPS",  "MESA_IMG_MGR_AE_CSTORE",
#	"MESA_OF_HOST",
#	"MESA_OF_PORT_DCM",	 "MESA_OF_AE_MWL",
#	"MESA_OF_PORT_HL7"
  );

  foreach $n (@names) {
#    print "$n\n";
    my $v = $h{$n};
#    print " $v \n";
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}


1;
