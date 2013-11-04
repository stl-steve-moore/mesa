#!/usr/local/bin/perl -w

use Env;

use lib "../common/scripts";
require mesa;

package pd_consumer;
require Exporter;

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
        "MESA_PDS_PORT_HL7", "MESA_PDS_HOST_HL7",
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

sub send_adt {
  my $adtDir = shift(@_);
  my $adtMsg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  if (! -e ("$adtDir/$adtMsg")) {
    print "Message $adtDir/$adtMsg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $adtDir/$adtMsg \n";
  print `$send_hl7 $target $port $adtDir/$adtMsg \n`;
  return 0 if $?;

  return 1;
}


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}


sub evaluate_XXX{
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_XXX $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
	"MSH", " 9", "0", "  7", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
	"QAK", " 2", "0", "  2", "Query Reponse Status   ", "ITI TF-2 Table 3.9-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}


1;
