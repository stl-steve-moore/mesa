#!/usr/local/bin/perl -w

# Package for Information Source scripts.

use Env;

use lib "../common/scripts";
require mesa;

package info_src;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"URLPrefix",
	"requestType", "documentUID",
	"preferredContentType",
	"Accept",
#	"Expires"	Don't check for this because the value is 0
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
