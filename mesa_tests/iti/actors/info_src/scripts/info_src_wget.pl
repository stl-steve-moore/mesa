#!/usr/local/bin/perl -w

# Runs the Information Source test cases

use Env;
use lib "scripts";
require info_src;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

my %types = (
	"image/jpeg", "jpg",
	"application/pdf", "pdf",
	"application/hl7-cda-level-one+xml", "cda"
	);

sub execute_wget {
  my ($logLevel, $testNumber, %names) = @_;
  my $URLPrefix		= $names{"URLPrefix"};
  my $requestType	= $names{"requestType"};
  my $documentUID	= $names{"documentUID"};
  my $preferredContentType = $names{"preferredContentType"};
  my $Accept		= $names{"Accept"};
  my $Expires		= $names{"Expires"};

  my $x = "$MESA_TARGET/bin/wget " .
        "--output-file=$testNumber/$testNumber.out " .
        "--directory-prefix=$testNumber " .
        "--output-document=$testNumber/$testNumber." .
           ($types{$preferredContentType} || "web" ) .
        " --header=\"Accept: $Accept\" "  .
        "\"$URLPrefix/IHERetrieveDocument" .
	"?requestType=$requestType" .
	"&documentUID=$documentUID" .
	"&preferredContentType=$preferredContentType\"" ;

  print "$x \n";

# Uncomment this when you are ready to go
  print `$x`;
#  return 1 if ($?);
  return 0;
}

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);

$host = `hostname`; chomp $host;
$testNumber = $ARGV[0];
$logLevel = $ARGV[1];

%varNames = mesa::get_config_params("$testNumber/$testNumber.txt");
if (info_src::test_var_names(%varNames) != 0) {
  print "Some problem with the variables in $testNumber/$testNumber.txt \n";
  exit 1;
}

print_config_params if ($logLevel >= 3);
my $x = execute_wget($logLevel, $testNumber, %varNames);
die "Could not execute wget test\n" if ($x != 0);

goodbye;
