#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains evaluation scripts
# for Japanese implementations.

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# evaluate_ADT_A04_Japanese

sub evaluate_ADT_A01_Japanese {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A01_Japanese $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", "26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", "26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"PID", " 3", "20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", "18", "20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "20", "Visit Number           ", "TF Vol III, Table 4.1-3",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testADT\n";
      return 1;		# Non-zero error count
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
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testADT\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaADT, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaADT\n";
      return 1;		# Non-zero error count
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
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_ADT_A04_Japanese {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A04_Japanese $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", "26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", "26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"PID", " 3", "20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", "18", "20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "20", "Visit Number           ", "TF Vol III, Table 4.1-3",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testADT\n";
      return 1;		# Non-zero error count
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
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testADT\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaADT, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaADT\n";
      return 1;		# Non-zero error count
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
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_ORM_O01_Japanese {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_O01_Japanese $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", " 20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", " 26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", " 26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"PID", " 3", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", "18", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 2", " 22", "Placer Order Number    ", "TF Vol II, Table 4.2-3",
	"ORC", " 7", "200", "Quantity / Timing      ", "TF Vol II, Table 4.2-3",
	"ORC", " 9", " 26", "Date/Time of Transact  ", "TF Vol II, Table 4.2-3",
	"OBR", " 2", " 22", "Placer Order Number    ", "TF Vol II, Table 4.2-4",
	"OBR", "27", "200", "Quantity / Timing      ", "TF Vol II, Table 4.2-4",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx++];
    my $field     = $nonZeroFields[$idx++];
    my $maxLen    = $nonZeroFields[$idx++];
    my $fieldName = $nonZeroFields[$idx++];
    my $reference = $nonZeroFields[$idx++];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$v>\n" if ($logLevel >= 3);

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
    #$idx += 5;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 3", "0", "0", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
	"PID", "18", "0", "0", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "0", "0", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 1", "0", "0", "  2", "Order Control          ", "TF Vol II, Table 4.2-3",
	"ORC", "12", "0", "0", "120", "Ordering Provider      ", "TF Vol II, Table 4.2-3",
	"ORC", "17", "0", "0", " 60", "Entering Organization  ", "TF Vol II, Table 4.2-3",
	"OBR", " 4", "0", "0", "200", "Universal Service ID   ", "TF Vol II, Table 4.2-4",
	"OBR", "16", "0", "0", "800", "Ordering Provider      ", "TF Vol II, Table 4.2-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$vTest>\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_ORM_O01_Filler_Japanese {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_O01_Filler Japanese $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", " 20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", " 26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", " 26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"PID", " 3", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", "18", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 3", " 22", "Filler Order Number    ", "TF Vol II, Table 4.2-3",
	"ORC", " 7", "200", "Quantity / Timing      ", "TF Vol II, Table 4.2-3",
	"ORC", " 9", " 26", "Date/Time of Transact  ", "TF Vol II, Table 4.2-3",
	"OBR", " 3", " 22", "Filler Order Number    ", "TF Vol II, Table 4.2-4",
	"OBR", "27", "200", "Quantity / Timing      ", "TF Vol II, Table 4.2-4",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx++];
    my $field     = $nonZeroFields[$idx++];
    my $maxLen    = $nonZeroFields[$idx++];
    my $fieldName = $nonZeroFields[$idx++];
    my $reference = $nonZeroFields[$idx++];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$v>\n" if ($logLevel >= 3);

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
    #$idx += 5;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 3", "0", "0", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
	"PID", "18", "0", "0", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "0", "0", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 1", "0", "0", "  2", "Order Control          ", "TF Vol II, Table 4.2-3",
	"ORC", "12", "0", "0", "120", "Ordering Provider      ", "TF Vol II, Table 4.2-3",
	"ORC", "17", "0", "0", " 60", "Entering Organization  ", "TF Vol II, Table 4.2-3",
	"OBR", " 4", "0", "0", "200", "Universal Service ID   ", "TF Vol II, Table 4.2-4",
	"OBR", "16", "0", "0", "800", "Ordering Provider      ", "TF Vol II, Table 4.2-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$vTest>\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_ORM_O01_scheduling_Japanese {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_O01_scheduling_Japanese $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", " 20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", " 26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", " 26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"PID", " 3", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", "18", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 3", " 22", "Filler Order Number    ", "TF Vol III, Table 4.4-3",
	"ORC", " 7", "200", "Quantity / Timing      ", "TF Vol III, Table 4.4-3",
	"OBR", " 1", "  4", "Set ID - OBR           ", "TF Vol III, Table 4.4-5",
	"OBR", " 3", " 22", "Filler Order Number    ", "TF Vol III, Table 4.4-5",
	"OBR", "18", " 16", "Placer field 1         ", "TF Vol III, Table 4.4-5",
	"OBR", "18", " 60", "Placer field 2         ", "TF Vol III, Table 4.4-5",
	"OBR", "20", " 60", "Filler field 1         ", "TF Vol III, Table 4.4-5",
	"OBR", "27", "200", "Quantity / Timing      ", "TF Vol III, Table 4.4-5",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx++];
    my $field     = $nonZeroFields[$idx++];
    my $maxLen    = $nonZeroFields[$idx++];
    my $fieldName = $nonZeroFields[$idx++];
    my $reference = $nonZeroFields[$idx++];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$v>\n" if ($logLevel >= 3);

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
    #$idx += 5;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 3", "0", "0", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
	"PID", "18", "0", "0", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "0", "0", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 1", "0", "0", "  2", "Order Control          ", "TF Vol III, Table 4.4-3",
	"ORC", " 2", "0", "0", " 22", "Placer Order Number    ", "TF Vol III, Table 4.4-3",
	"ORC", " 5", "0", "0", "  2", "Order Status           ", "TF Vol III, Table 4.4-3",
	"OBR", " 2", "0", "0", " 22", "Placer Order Number    ", "TF Vol III, Table 4.4-5",
	"OBR", " 4", "0", "0", "200", "Universal Service ID   ", "TF Vol III, Table 4.4-5",
	"OBR", "24", "0", "0", " 10", "Diag Service Sect ID   ", "TF Vol III, Table 4.4-5",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$vTest>\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_ORM_O01_cancel_Japanese {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_O01_cancel_Japanese $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", " 20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"EVN", " 2", " 26", "Recorded DateTime      ", "TF Vol II, Table 4.1.4.1.2.2",
	"EVN", " 6", " 26", "Event Occurred         ", "TF Vol II, Table 4.1.4.1.2.2",
	"ORC", " 2", " 22", "Placer Order Number    ", "TF Vol III, Table 4.4-3",
	"ORC", " 3", " 22", "Filler Order Number    ", "TF Vol III, Table 4.4-3",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx++];
    my $field     = $nonZeroFields[$idx++];
    my $maxLen    = $nonZeroFields[$idx++];
    my $fieldName = $nonZeroFields[$idx++];
    my $reference = $nonZeroFields[$idx++];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$v>\n" if ($logLevel >= 3);

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
    #$idx += 5;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"MSH", "18", "0", "0", " 60", "Character Set          ", "xxx",
	"PID", " 3", "0", "0", " 20", "Patient Identifier List", "TF Vol III, Table 4.1-2",
	"PID", " 5", "0", "0", " 48", "Patient Name           ", "TF Vol III, Table 4.1-2",
	"PID", "18", "0", "0", " 20", "Patient Account Number ", "TF Vol III, Table 4.1-2",
	"PV1", "19", "0", "0", " 20", "Visit Number           ", "TF Vol III, Table 4.1-3",
	"ORC", " 1", "0", "0", "  2", "Order Control          ", "TF Vol III, Table 4.4-3",
	"ORC", " 2", "0", "0", " 22", "Placer Order Number    ", "TF Vol III, Table 4.4-3",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx++];
    my $field     = $equivalentFields[$idx++];
    my $component = $equivalentFields[$idx++];
    my $repetition= $equivalentFields[$idx++];
    my $maxLen    = $equivalentFields[$idx++];
    my $fieldName = $equivalentFields[$idx++];
    my $reference = $equivalentFields[$idx++];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: length: $len" if ($logLevel >= 3);
    print main::LOG " " if ($logLevel >= 3 && $len < 100);
    print main::LOG " " if ($logLevel >= 3 && $len < 10);
    print main::LOG ": <$vTest>\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    #$idx += 5;
  }

  return $errorCount
}

sub evaluate_one_mwl_resp_Japanese {
  my ($logLevel, $testFile, $stdFile) = @_;

  my $evalString = "$main::MESA_TARGET/bin/cfind_mwl_evaluate " .
     " -l $logLevel " .
     " -L Japanese "  .
     " $testFile $stdFile";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);
  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_mpps_mpps_mgr_Japanese {
  my ($logLevel, $stdDir, $storageDir, $testNumber) = @_;

  if (! -e($storageDir)) {
    print main::LOG "ERR: MESA storage directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDir \n";
    print main::LOG "ERR:  Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  if (! open(MPPS_HANDLE, "< $stdDir/mpps_uid.txt")) {
    print main::LOG "ERR: Could not open MPPS UID File: $stdDir/mpps_uid.txt\n";
    return 1;
  }

  $mpps_UID = <MPPS_HANDLE>;
  chomp $mpps_UID;
  print main::LOG "CTX: MPPS UID = $mpps_UID \n" if ($logLevel >= 3);

  if (! -e("$storageDir/$mpps_UID")) {
    print main::LOG "ERR: MESA MPPS directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDir/$mpps_UID \n";
    print main::LOG "ERR:  This implies you did not forward MPPS messages for these MPPS events.\n";
    return 1;
  }

  if (! -e("$storageDir/$mpps_UID/mpps.dcm")) {
    print main::LOG "ERR: MPPS status file does not exist \n";
    print main::LOG "ERR:  File is expected to be: $storageDir/$mpps_UID/mpps.dcm \n";
    print main::LOG "ERR:  This implies a problem in the MESA software because the directory exists but the file is missing.\n";
    return 1;
  }

  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate " .
	" -L Japanese " .
	" -l $logLevel " .
	" mgr $testNumber $storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_cfind_resp_Japanese {
  my ($logLevel, $group, $element, $maskFile, $tstDir, $stdDir) = @_;

  if (! -e($tstDir)) {
    print main::LOG "ERR: Evaluation of C-Find responses failed.\n";
    print main::LOG "ERR: Directory with test messages: $tstDir does not exist.\n";
    return 1;
  }
  if (! -e($stdDir)) {
    print main::LOG "ERR: Evaluation of C-Find responses failed.\n";
    print main::LOG "ERR: Directory with standard messages: $sdtDir does not exist.\n";
    return 1;
  }
  $evalString = "$main::MESA_TARGET/bin/cfind_resp_evaluate " .
		" -l $logLevel -L Japanese " .
		"$group $element $maskFile $tstDir $stdDir";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

# This section generally contains evaluation scripts targeted
# for an Acquisition Modality actor.

sub eval_image_unscheduled_Japanese
{
  my $level      = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -L Japanese -l $level -p $masterFile " .
	" $testFile";

  print main::LOG "$x\n" if $level >= 3;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for unscheduled case \n";
    print main::LOG "ERR  File name is $testFile\n";
    return 1;
  }
  return 0;
}

sub eval_image_scheduled_Japanese
{
  my $level      = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -L Japanese -l $level -o mwl -p $masterFile " .
	" $testFile";

  print main::LOG "$x\n" if $level >= 3;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for scheduled (simple) case \n";
    print main::LOG "ERR  File name is $testFile\n";
    return 1;
  }
  return 0;
}

sub eval_image_scheduled_group_case_Japanese
{
  print main::LOG "sub eval_image_scheduled_group_case_Japanese\n";
  my ($level, $masterFile, $testFile) = @_;

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -L Japanese -l $level -o nouid -o mwl -p $masterFile " .
	" $testFile";

  print main::LOG "$x\n" if $level >= 3;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for scheduled (group) case \n";
    print main::LOG "ERR  File name is $testFile\n";
    return 1;
  }
  return 0;
}

sub evaluate_mpps_modality_Japanese {
  my ($logLevel, $aet, $masterFile, $testFile) = @_;

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG " This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "In comparing MPPS, we are missing the MPPS status:\n" .
        "  $testFile\n";
    print main::LOG " You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  my $testNumber = 1;		# Hard-coded for modality tests
  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate " .
	" -L Japanese " .
	" -l $logLevel " .
	" mod $testNumber $testFile $masterFile";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_mpps_modality_group_Japanese {
  my ($logLevel, $aet, $masterFile, $testFile) = @_;

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG " This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "In comparing MPPS, we are missing the MPPS status:\n" .
        "  $testFile\n";
    print main::LOG " You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mpps_evaluate " .
	" -L Japanese -l $logLevel " .
	" mod 3 $testFile $masterFile ";

  print main::LOG "$x\n" if $logLevel > 2;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "MPPS comparison failed for unscheduled case \n";
    print main::LOG " File name is $testFile \n";
    return 1;
  }
  return 0;
}

1;
