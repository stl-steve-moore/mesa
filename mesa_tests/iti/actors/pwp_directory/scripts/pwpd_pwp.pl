#!/usr/local/bin/perl -w

# Runs the PWP Directory tests

use Env;
use lib "scripts";
require pwp_directory;

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

# Main starts here

die "Usage: <test number> <output level: 0-4>\n" if (scalar(@ARGV) < 2);


$host = `hostname`; chomp $host;
$testNumber = $ARGV[0];
#$logLevel   = $ARGV[1];

%varnames = mesa::get_config_params("pwp_directory.cfg");
#print_config_params();

$testDirectoryHost = $varnames{"TEST_DIRECTORY_HOST"};
$testBaseDN        = $varnames{"TEST_BASE_DN"};

my $fileName = "../common/$testNumber/$testNumber" . ".txt";
open TESTFILE, $fileName or die "Could not open: $fileName\n";
$queryPattern = <TESTFILE>; chomp $queryPattern;
$searchScope  = <TESTFILE>; chomp $searchScope;
$baseDNFlag   = <TESTFILE>; chomp $baseDNFlag;
$attributes = <TESTFILE>;
if (!$attributes) {
 $attributes = "";
}
chomp $attributes;
close TESTFILE;

$testBaseDN = "" if ($baseDNFlag eq "BASEDN_NULL");

my $query = "ldapsearch -S \"\" -LLL -H ldap://$testDirectoryHost -x -s $searchScope -b '$testBaseDN' '$queryPattern' $attributes";
#my $query = "ldapsearch -S \"\" -LLL -H ldap://$testDirectoryHost -x -b 'dc=ihe,dc=net' '$queryPattern' dn cn displayName employeeNumber pager title mail uid";
#my $query = "ldapsearch -v -n -H ldap://$testDirectoryHost -f ../common/$testNumber/$testNumber.txt -x -b 'dc=ihe,dc=net' 'cn=Mooney^*'";
#my $query = "ldapsearch -v -n -H ldap://$testDirectoryHost -f - -x -b 'dc=ihe,dc=net' < ../common/$testNumber/$testNumber.txt";
print "$query\n";

open LOG, ">$testNumber/$testNumber.qry.txt" or die "Could not open output file $testNumber/$testNumber.qry.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

print LOG `$query`;

#if (id_src::test_var_names(%varnames) != 0) {
#  print "Some problem with the variables in id_src.cfg\n";
#  exit 1;
#}
#
#$mesaXRefPortHL7 = $varnames{"MESA_XREF_PORT_HL7"};
#
#print `perl scripts/reset_servers.pl`;
#die "Could not reset servers \n" if ($?);
#
#my $fileName = "../common/$ARGV[0]/$ARGV[0]" . ".txt";
#open TESTFILE, $fileName or die "Could not open: $fileName\n";
#
#$logLevel = $ARGV[1];
#$selfTest = 0;
#$selfTest = 1 if (scalar(@ARGV) > 2);
#print "MESA XRef Mgr Port HL7 = $mesaXRefPortHL7\n";
#
#while ($l = <TESTFILE>) {
#  chomp $l;
#  $v = processOneLine($l, $logLevel, $selfTest);
#  die "Could not process line $l" if ($v != 0);
#}
#close TESTFILE;

goodbye;
