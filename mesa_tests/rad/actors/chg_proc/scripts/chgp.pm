#!/usr/local/bin/perl -w

# Package for Charge Processor scripts.

use Env;

use lib "../common/scripts";
require mesa;

package chgp;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw( 
#);


#sub read_config_params {
#  my $f = shift(@_);
#  open (CONFIGFILE, $f) or die "Can't open $f.\n";
#  while ($line = <CONFIGFILE>) {
#    chomp($line);
#    next if $line =~ /^#/;
#    next unless $line =~ /\S/;
#    ($varname, $varvalue) = split(" = ", $line);
#    $varnames{$varname} = $varvalue;
#  }
#  my $portHL7 = $varnames{"TEST_HL7_PORT"};
#  my $hostHL7 = $varnames{"TEST_HL7_HOST"};
#
#  return ($portHL7, $hostHL7);
#}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
        "TEST_HL7_HOST",
        "TEST_HL7_PORT",
  );

  foreach $n (@names) {
    my $v = $h{$n};
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}

1;
