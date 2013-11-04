#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package pwp_directory;
require Exporter;

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"TEST_PWP_DIRECTORY_HOST_LDAP", "TEST_PWP_DIRECTORY_PORT_LDAP",
	"MESA_PWP_DIRECTORY_HOST_LDAP", "MESA_PWP_DIRECTORY_PORT_LDAP"
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

sub send_ldap_query {
  my ($logLevel, $hostLDAP, $portLDAP, $queryLDAP, $outputDirectory) = @_;

  print "Sending LDAP query to ($hostLDAP:$portLDAP)\n" if ($logLevel >= 3);

  return 0;
}

# This subroutine courtesy of Perl Cookbook, ch. 1.14.  Strips whitespace from beginning and ends
# of strings in scalar or array context.
#   $str = trim_whitespace($str);
#   @many = trim_whitespace(@many);
sub trim_whitespace {
  my @out = @_;
  for (@out) {
    s/^\s+//;
    s/\s+$//;
  }
  return wantarray ? @out : $out[0];
}


sub readLDAPRecords {
  my ($fileName) = @_;
  open R, "<$fileName" or die "readLDAPRecords: Could not read input $fileName";

  my $l = <R>;		# This is the header line listing MESA version
  my $record = "";
  my $count = 0;
  my %h;
NEXT_LDAP:  while ($l = <R>) {
    next NEXT_LDAP if ($l eq "\n");
    $record .= $l;
    my ($att, $val) = trim_whitespace(split(":", $l));
    if ($att eq "uid") {
      $h{$val} = $record;
      $record = "";
#      print main::LOG "CTX: Just completed record $count $l\n";
      $count += 1;
    }
  }

  return ($count, %h);
}

sub compareTwoLDAPRecords {
  my ($logLevel, $mesaRecord, $testRecord) = @_;
  my %mesaHash;
  my %testHash;

  my $rtnValue = 0;
  @attributes = split("\n", $mesaRecord);
  foreach $a(@attributes) {
    print main::LOG "CTX: MESA $a\n" if ($logLevel >= 3);
    my ($att, $val) = trim_whitespace(split(":", $a));
    $mesaHash{$att} = $val;
  }
  @attributes = split("\n", $testRecord);
  foreach $a(@attributes) {
    print main::LOG "CTX: TEST $a\n" if ($logLevel >= 3);
    my ($att, $val) = trim_whitespace(split(":", $a));
    $testHash{$att} = $val;
  }
  while ( ($key, $mesaValue) = each %mesaHash) {
    my $testValue = $testHash{$key};
    print main::LOG "CTX: Key $key MESA <$mesaValue> TEST <$testValue>\n" if ($logLevel >= 3);
    if ($mesaValue ne $testValue) {
      $rtnValue = 1;
      print main::LOG "ERR: TEST LDAP value <$testValue> for key $key does not equal MESA value <$mesaValue>\n";
    }
  }

  return $rtnValue;
}

sub evaluate_LDAP_response {
  my ($logLevel, $mesaFile, $testFile) = @_;
  print main::LOG "CTX: Evaluating LDAP response in directory: $testFile\n" if ($logLevel >= 3);

  my $mesaRecordCount = 0;
  my %mesaRecords;
  ($mesaRecordCount, %mesaRecords) = readLDAPRecords($mesaFile);
  ($testRecordCount, %testRecords) = readLDAPRecords($testFile);
  if ($mesaRecordCount != $testRecordCount) {
    print main::LOG "ERR: Number of LDAP records differs in MESA response and test system response\n";
    print main::LOG "ERR: MESA LDAP record count: $mesaRecordCount\n";
    print main::LOG "ERR: Test LDAP record count: $testRecordCount\n";
    return 1;
  }
  print main::LOG "CTX: LDAP record count $mesaRecordCount\n" if ($logLevel >= 3);
  my $rtnValue = 0;

  my $count = 1;
  while ( ($key, $mesaRecord) = each %mesaRecords) {
    my $uidValue = $key;
    print main::LOG "CTX: Starting a new MESA record: $count\n" if ($logLevel >= 3);
    $testRecord = $testRecords{$uidValue};
    if (!$testRecord) {
      print main::LOG "ERR: Did not find a matching LDAP record for UID: $uidValue\n";
      $rtnValue = 1;
    } else {
      my $x = compareTwoLDAPRecords($logLevel, $mesaRecord, $testRecord);
      print main::LOG "ERR: MESA and TEST LDAP records differ\n" if ($x != 0);
      $rtnValue = 1 if ($x != 0);
    }
##    print main::LOG "CTX: $r\n";
  }

  return $rtnValue;
}


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

