#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains all the announcments.

use Env;
use Date::Manip;
require 5.001;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
#@EXPORT = qw(
#);

#Subroutines found in this module.

# evaluate_ORM_PlacerOrder 
# evaluate_ORM_scheduling 
# evaluate_ORM_scheduling_post_procedure 
# evaluate_ADT_A04 
# evaluate_ADT_A08 
# evaluate_one_mwl_resp 
# evaluate_mpps_mpps_mgr 


sub evaluate_ORM_PlacerOrder {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_PlacerOrder $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  # PID
  # PID 3, Patient ID List
  my $patientID =     mesa::getField($testORM, "PID", "3", "0", "Patient ID List");
  my $mesaPatientID = mesa::getField($mesaORM, "PID", "3", "0", "Patient ID List");
  $len = length ($patientID);
  print main::LOG "CTX: PID  3 Patient ID List:                       $patientID, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  3: Patient ID List is empty\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientID ne $mesaPatientID) {
    print main::LOG "ERR: PID  3: Patient ID List from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientID\n";
    print main::LOG "ERR: MESA value: $mesaPatientID\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 5, Patient Name
  my $patientName =     mesa::getField($testORM, "PID", "5", "0", "Patient Name");
  my $mesaPatientName = mesa::getField($mesaORM, "PID", "5", "0", "Patient Name");
  $len = length ($patientName);
  print main::LOG "CTX: PID  5 Patient Name:                          $patientName, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  5: Patient Name is empty\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientName ne $mesaPatientName) {
    print main::LOG "ERR: PID  5: Patient Name from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientName\n";
    print main::LOG "ERR: MESA value: $mesaPatientName\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 18, Patient Account Number
  my $patientAccount =     mesa::getField($testORM, "PID", "18", "0", "Patient Account Number");
  my $mesaPatientAccount = mesa::getField($mesaORM, "PID", "18", "0", "Patient Account Number");
  $len = length ($patientAccount);
  print main::LOG "CTX: PID 18 Patient Account:                       $patientAccount, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 18: Patient Account Number is empty\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientAccount ne $mesaPatientAccount) {
    print main::LOG "ERR: PID 18: Patient Account Number from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientAccount\n";
    print main::LOG "ERR: MESA value: $mesaPatientAccount\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.2-1\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1
  # PV1 2, Patient Class
  my $patientClass =     mesa::getField($testORM, "PV1", "2", "0", "Patient Class");
  my $mesaPatientClass = mesa::getField($mesaORM, "PV1", "2", "0", "Patient Class");
  $len = length ($patientClass);
  print main::LOG "CTX: PV1  2 Patient Class:                         $patientClass, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  2: Patient Class is empty\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.2-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientClass ne $mesaPatientClass) {
    print main::LOG "ERR: PV1  2: Patient Class from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientClass\n";
    print main::LOG "ERR: MESA value: $mesaPatientClass\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.2-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC
  # ORC 1, Order Control
  my $orderControl =     mesa::getField($testORM, "ORC", "1", "0", "Order Control");
  my $mesaOrderControl = mesa::getField($mesaORM, "ORC", "1", "0", "Order Control");
  $len = length ($orderControl);
  print main::LOG "CTX: ORC  1 Order Control:                         $orderControl, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC  1: Order Control is empty\n";
    print main::LOG "REF: ORC  1: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($orderControl ne $mesaOrderControl) {
    print main::LOG "ERR: ORC  1: Order Control from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $orderControl\n";
    print main::LOG "ERR: MESA value: $mesaOrderControl\n";
    print main::LOG "REF: ORC  1: See TF Vol II, Table 4.2-3 and supported Order Control Codes below\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 2, Placer Order Number
  my $placerOrderNumber =     mesa::getField($testORM, "ORC", "2", "0", "Placer Order Number");
  #my $mesaPlacerOrderNumber = mesa::getField($mesaORM, "ORC", "2", "0", "Placer Order Number");
  $len = length ($placerOrderNumber);
  print main::LOG "CTX: ORC  2 Placer Order Number:                   $placerOrderNumber, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC  2: Placer Order Number should not be zero length\n";
    print main::LOG "REF: ORC  2: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 22) {
    print main::LOG "ERR: ORC  2: Placer Order Number length is constrained to 22 characters\n";
    print main::LOG "ERR: ORC  2: Your Placer Order Number length is $len\n";
    print main::LOG "ERR: Test value: $placerOrderNumber\n";
    print main::LOG "REF: ORC  2: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 3, Filler Order Number
  my $fillerOrderNumber =     mesa::getField($testORM, "ORC", "3", "0", "Filler Order Number");
  #my $mesaFillerOrderNumber = mesa::getField($mesaORM, "ORC", "3", "0", "Filler Order Number");
  $len = length ($fillerOrderNumber);
  print main::LOG "CTX: ORC  3 Filler Order Number:                   $fillerOrderNumber, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: ORC  3: Filler Order Number should not be present\n";
    print main::LOG "ERR: Test value: $fillerOrderNumber\n";
    print main::LOG "REF: ORC  3: See TF Vol II, Table 4.2-3 and notes below\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 7, Quantity Timing
  my $quantityTiming =     mesa::getField($testORM, "ORC", "7", "0", "Quantity Timing");
  #my $mesaQuantityTiming = mesa::getField($mesaORM, "ORC", "7", "0", "Quantity Timing");
  $len = length ($quantityTiming);
  print main::LOG "CTX: ORC  7 Quantity / Timing:                     $quantityTiming, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC  7: Quantity / Timing should not be zero length\n";
    print main::LOG "REF: ORC  7: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 200) {
    print main::LOG "ERR: ORC  7: Quantity / Timing length is constrained to 200 characters\n";
    print main::LOG "ERR: ORC  7: Your Quantity/Timing length is $len\n";
    print main::LOG "ERR: Test value: $quantityTiming\n";
    print main::LOG "REF: ORC  7: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 9, Date/Time of Transaction
  my $dateTime =     mesa::getField($testORM, "ORC", "9", "0", "Date/Time of Transaction");
  #my $mesaDateTime = mesa::getField($mesaORM, "ORC", "9", "0", "Date/Time of Transaction");
  $len = length ($dateTime);
  print main::LOG "CTX: ORC  9 Date/Time of Transaction:              $dateTime, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC  9: Date/Time of Transaction should not be zero length\n";
    print main::LOG "REF: ORC  9: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 26) {
    print main::LOG "ERR: ORC  9: Date/Time of Transaction length is constrained to 26 characters\n";
    print main::LOG "ERR: ORC  9: Your Date/Time of Transaction length is $len\n";
    print main::LOG "ERR: Test value: $dateTime\n";
    print main::LOG "REF: ORC  9: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 12, Ordering Provider
  my $orderingProvider =     mesa::getField($testORM, "ORC", "12", "0", "Ordering Provider");
  my $mesaOrderingProvider = mesa::getField($mesaORM, "ORC", "12", "0", "Ordering Provider");
  $len = length ($orderingProvider);
  print main::LOG "CTX: ORC 12 Ordering Provider:                     $orderingProvider, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC 12: Ordering Provider should not be zero length\n";
    print main::LOG "REF: ORC 12: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($orderingProvider ne $mesaOrderingProvider) {
    print main::LOG "ERR: ORC 12: Ordering Provider from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $orderingProvider\n";
    print main::LOG "ERR: MESA value: $mesaOrderingProvider\n";
    print main::LOG "REF: ORC 12: See TF Vol II, Table 4.2-3 \n" if ($logLevel >= 4);
    $errorCount++;
  }

  # ORC 17, Entering Organization
  my $enteringOrg =     mesa::getField($testORM, "ORC", "17", "0", "Entering Organization");
  my $mesaEnteringOrg = mesa::getField($mesaORM, "ORC", "17", "0", "Entering Organization");
  $len = length ($enteringOrg);
  print main::LOG "CTX: ORC 17 Entering Organization:                 $enteringOrg, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: ORC 17: Entering Organization should not be zero length\n";
    print main::LOG "REF: ORC 17: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 60) {
    print main::LOG "ERR: ORC 17: Entering Organization length is constrained to 60 characters\n";
    print main::LOG "ERR: ORC 17: Your Entering Organization length is $len\n";
    print main::LOG "ERR: Test value: $enteringOrganization\n";
    print main::LOG "REF: ORC 17: See TF Vol II, Table 4.2-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # OBR Segment
  # OBR 2, Placer Order Number
  my $placerOrderNumberOBR =     mesa::getField($testORM, "OBR", "2", "0", "Placer Order Number");
  print main::LOG "CTX: OBR  2 Placer Order Number:                   $placerOrderNumberOBR, length: $len\n" if ($logLevel >= 3);
  if ($placerOrderNumber ne $placerOrderNumberOBR) {
    print main::LOG "ERR: OBR  2: Placer Order Number is not the same as in ORC 2 \n";
    print main::LOG "ERR: OBR  2: Placer Order Number: $placerOrderNumberOBR \n";
    print main::LOG "ERR: ORC  2: Placer Order Number: $placerOrderNumber \n";
    print main::LOG "REF: OBR  2: See TF Vol II, Table 4.2-4 and notes below\n" if ($logLevel >= 4);
  }

  # OBR 3, Filler Order Number
  my $fillerOrderNumberOBR =     mesa::getField($testORM, "OBR", "3", "0", "Filler Order Number");
  #my $mesaFillerOrderNumberOBR = mesa::getField($mesaORM, "OBR", "3", "0", "Filler Order Number");
  $len = length ($fillerOrderNumberOBR);
  print main::LOG "CTX: OBR  3 Filler Order Number:                  $fillerOrderNumberOBR, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: OBR  3: Filler Order Number should not be present\n";
    print main::LOG "ERR: Test value: $fillerOrderNumberOBR\n";
    print main::LOG "REF: OBR  3: See TF Vol II, Table 4.2-3, Table 4.2-4 and notes below\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # OBR 4, Universal Service ID
  my $universalServiceID = mesa::getField($testORM, "OBR", "4", "0", "Universal Service ID (Requested/Scheduled Procedure Codes)");
  my $mesaUniversalServiceID = mesa::getField($mesaORM, "OBR", "4", "0", "Universal Service ID (Requested/Scheduled Procedure Codes)");
  $len = length ($universalServiceID);
  print main::LOG "CTX: OBR  4 Univ Serv ID (Req Procedure Codes):    $universalServiceID, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: OBR  4: Universal Service ID, Requested/Scheduled Procedure Codes is empty\n";
    print main::LOG "REF: OBR  4: See TF Vol II, Table 4.2-4\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($universalServiceID ne $mesaUniversalServiceID) {
    print main::LOG "ERR: OBR  4: Universal Service ID from your scheduling message does not match MESA value\n";
    print main::LOG "ERR: Test value: $universalServiceID\n";
    print main::LOG "ERR: MESA value: $mesaUniversalServiceID\n";
    print main::LOG "REF: OBR  4: See TF Vol II, Table 4.2-4\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # OBR 12, Ordering Provider
  my $orderingProviderOBR =     mesa::getField($testORM, "OBR", "16", "0", "Ordering Provider");
  my $mesaOrderingProviderOBR = mesa::getField($mesaORM, "OBR", "16", "0", "Ordering Provider");
  $len = length ($orderingProviderOBR);
  print main::LOG "CTX: OBR 16 Ordering Provider:                     $orderingProviderOBR, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: OBR 16: Ordering Provider should not be zero length\n";
    print main::LOG "REF: OBR 16: See TF Vol II, Table 4.2-4\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($orderingProviderOBR ne $mesaOrderingProviderOBR) {
    print main::LOG "ERR: OBR 16: Ordering Provider from your order message does not match MESA value\n";
    print main::LOG "ERR: Test value: $orderingProviderOBR\n";
    print main::LOG "ERR: MESA value: $mesaOrderingProviderOBR\n";
    print main::LOG "REF: OBR 16: See TF Vol II, Table 4.2-4 \n" if ($logLevel >= 4);
    $errorCount++;
  }

  # OBR 27, Quantity/Timing
  my $quantityTimingOBR =     mesa::getField($testORM, "OBR", "27", "0", "Quantity/Timing");
  print main::LOG "CTX: OBR 27 Quantity/Timing:                       $quantityTimingOBR, length: $len\n" if ($logLevel >= 3);
  if ($quantityTiming ne $quantityTimingOBR) {
    print main::LOG "ERR: OBR 27: Quantity/Timing is not the same as in ORC 7 \n";
    print main::LOG "ERR: OBR 27: Quantity/Timing: $quanityTimingOBR\n";
    print main::LOG "ERR: ORC  7: Quantity/Timing: $quantityTiming\n";
    print main::LOG "REF: OBR  2: See TF Vol II, Table 4.2-4 and notes below\n" if ($logLevel >= 4);
  }

  return $errorCount;
}

sub evaluate_ORM_FillerOrder {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_FillerOrder $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "0",  "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"ORC", " 3", "0",  "20", "Filler Order Number    ", "TF Vol II, Table 4.3-3",
#	"ORC", " 7", "4", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"OBR", " 3", "0",  "20", "Filler Order Number    ", "TF Vol II, Table 4.3-4",
#	"OBR", "27", "4", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-4",
  );

  print main::LOG "CTX: Testing for fields that should not be 0-length\n";
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $subComp   = $nonZeroFields[$idx+2];
    my $maxLen    = $nonZeroFields[$idx+3];
    my $fieldName = $nonZeroFields[$idx+4];
    my $reference = $nonZeroFields[$idx+5];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "ERR: Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "ERR: File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

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
    $idx += 6;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "0", " 48", "Patient ID             ", "TF Vol II, Table ",
	"PID", " 5", "0", " 48", "Patient Name           ", "TF Vol II, Table ",
	"ORC", " 1", "0", "  2", "Order Control          ", "TF Vol II, Table 4.2-3",
	"ORC", " 7", "1", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"ORC", " 7", "2", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"ORC", "12", "0", " 48", "Ordering Provider      ", "TF Vol II, Table 4.4-3",
	"ORC", "17", "0", " 48", "Entering Organization  ", "TF Vol II, Table 4.4-3",
	"OBR", " 4", "0", "200", "Universal Service ID   ", "TF Vol II, Table 4.4-3",
	"OBR", "16", "0", " 80", "Ordering Provider      ", "TF Vol II, Table 4.4-3",
	"OBR", "27", "1", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"OBR", "27", "2", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"OBR", "31", "0", "300", "Reason for Study       ", "TF Vol II, Table 4.4-3",
  );

  print main::LOG "CTX: Testing for fields that should match a specific value\n";
  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $subComp   = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

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

  return $errorCount
}

sub evaluate_ORM_scheduling {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_scheduling $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "0",  "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"ORC", " 3", "0",  "22", "Filler Order Number    ", "TF Vol II, Table 4.3-3",
#	"ORC", " 7", "4", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-3",
	"OBR", " 3", "0",  "22", "Filler Order Number    ", "TF Vol II, Table 4.3-4",
	"OBR", "18", "0",  "16", "Placer Field 1 Access #", "TF Vol II, Table 4.4-6",
	"OBR", "19", "0",  "20", "Placer Field 2 Req Proc", "TF Vol II, Table 4.4-6",
	"OBR", "20", "0",  "20", "Filler Field 1 SPS ID  ", "TF Vol II, Table 4.4-6",
#	"OBR", "27", "4", "200", "Quantity/Timing        ", "TF Vol II, Table 4.3-4",
  );

  print main::LOG "CTX: Testing for fields that should not be 0-length\n";
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $subComp   = $nonZeroFields[$idx+2];
    my $maxLen    = $nonZeroFields[$idx+3];
    my $fieldName = $nonZeroFields[$idx+4];
    my $reference = $nonZeroFields[$idx+5];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "ERR: Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "ERR: File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

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
    $idx += 6;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "0", " 48", "Patient ID             ", "TF Vol II, Table ",
	"PID", " 5", "0", " 48", "Patient Name           ", "TF Vol II, Table ",
	"ORC", " 1", "0", "  2", "Order Control          ", "TF Vol II, Table 4.2-3",
	"OBR", " 4", "0", "200", "Universal Service ID   ", "TF Vol II, Table 4.4-3",
	"OBR", "24", "0", "200", "Diag Service Section ID", "TF Vol II, Table 4.4-3",
  );

  print main::LOG "CTX: Testing for fields that should match a specific value\n";
  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $subComp   = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

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

#======================

# OBR 4, Universal Service ID
#  my $universalServiceID = mesa::getField($testORM, "OBR", "4", "0", "Universal Service ID (Requested/Scheduled Procedure Codes)");
#  my $mesaUniversalServiceID = mesa::getField($mesaORM, "OBR", "4", "0", "Universal Service ID (Requested/Scheduled Procedure Codes)");
#  $len = length ($universalServiceID);
#  print main::LOG "CTX: OBR  4 Univ Serv ID (Req/Schedu Procedure Codes):    $universalServiceID, length: $len\n" if ($logLevel >= 3);
#
#  if ($len == 0) {
#    print main::LOG "ERR: OBR  4: Universal Service ID, Requested/Scheduled Procedure Codes is empty\n";
#    print main::LOG "REF: OBR  4: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  } elsif ($universalServiceID ne $mesaUniversalServiceID) {
#    print main::LOG "ERR: OBR  4: Universal Service ID from your scheduling message does not match MESA value\n";
#    print main::LOG "ERR: Test value: $universalServiceID\n";
#    print main::LOG "ERR: MESA value: $mesaUniversalServiceID\n";
#    print main::LOG "REF: OBR  4: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  }

#  my $placerField1 = mesa::getField($testORM, "OBR", "18", "0", "Placer Field 1 (Accession Num)");
#  $len = length ($placerField1);
#  print main::LOG "CTX: OBR 18 Placer Field 1 (AccessionNumber):             $placerField1, length: $len\n" if ($logLevel >= 3);
#
#  if ($len == 0) {
#    print main::LOG "ERR: OBR 18: Placer Field 1, Accession Number is empty\n";
#    print main::LOG "REF: OBR 18: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  } elsif ($len > 16) {
#    print main::LOG "ERR: OBR 18: Length of Accession Number ($placerField1 $len) exceeds 16 characters\n";
#    print main::LOG "REF: OBR 18: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  }

#  my $placerField2 = mesa::getField($testORM, "OBR", "19", "0", "Placer Field 2 (Requested Procedure ID)");
#  $len = length ($placerField2);
#  print main::LOG "CTX: OBR 19 Placer Field 2 (Requested Procedure ID):      $placerField2, length: $len\n" if ($logLevel >= 3);
#
#  if ($len == 0) {
#    print main::LOG "ERR: OBR 19: Placer Field 2, Requested Procedure ID is empty\n";
#    print main::LOG "REF: OBR 19: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  }

#  my $fillerField1 = mesa::getField($testORM, "OBR", "20", "0", "Filler Field 1 (Scheduled Procedure Step ID)");
#  $len = length ($fillerField1);
#  print main::LOG "CTX: OBR 20 Filler Field 1 (Scheduled Procedure Step ID): $fillerField1, length: $len\n" if ($logLevel >= 3);
#
#  if ($len == 0) {
#    print main::LOG "ERR: OBR 20: Filler Field 1, Scheduled Procedure Step ID is empty\n";
#    print main::LOG "REF: OBR 20: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  }

# OBR 24, Diagnostic Service Section ID
#  my $diagServiceSectionID = mesa::getField($testORM, "OBR", "24", "0", "Diag Service Section ID (Modality)");
#  my $mesaDiagServiceSectionID = mesa::getField($mesaORM, "OBR", "24", "0", "Diag Service Section ID (Modality))");
#  $len = length ($diagServiceSectionID);
#  print main::LOG "CTX: OBR 24 Diagnostic Service Section ID (Modality):     $diagServiceSectionID, length: $len\n" if ($logLevel >= 3);
#
#  if ($len == 0) {
#    print main::LOG "ERR: OBR 24: Diagnostic Service Section ID (Modality) is empty\n";
#    print main::LOG "REF: OBR 24: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  } elsif ($diagServiceSectionID ne $mesaDiagServiceSectionID) {
#    print main::LOG "ERR: OBR  4: Diagnostic Service Section ID from your scheduling message does not match MESA value\n";
#    print main::LOG "ERR: Test value: $diagServiceSectionID\n";
#    print main::LOG "ERR: MESA value: $mesaDiagServiceSectionID\n";
#    print main::LOG "REF: OBR 24: See TF Vol II, Table 4.4-6\n" if ($logLevel >= 4);
#    $errorCount++;
#  }
#
  return $errorCount;
}

sub evaluate_ORM_scheduling_post_procedure {
  my ($logLevel, $mesaORM, $testORM, $modDirectory) = @_;
  my $errorCount = 0;

  $errorCount = mesa::evaluate_ORM_scheduling($logLevel, $mesaORM, $testORM);

  my $mppsFile = "$modDirectory/mpps.status";
  my ($x, $performedStudyInsUID) = mesa::getDICOMAttribute($logLevel, $mppsFile, "0020 000D", "0040 0270");
  if ($x == 0) {
    my ($y, $scheduledStudyInsUID) = mesa::getHL7Field($logLevel, $testORM, "ZDS", "1", "1", "Study Instance UID");
    print main::LOG "CTX: Performed Study Ins UID: $performedStudyInsUID \n" if ($logLevel >= 3);
    print main::LOG "CTX: Scheduled Study Ins UID: $scheduledStudyInsUID \n" if ($logLevel >= 3);
    if ($y != 0) {
      print main::LOG "ERR: Unable to get Scheduled Study Ins UID in HL7 scheduling message $testORM\n";
      $errorCount += 1;
    } elsif ($performedStudyInsUID ne $scheduledStudyInsUID) {
      print main::LOG "ERR: Performed Study Ins UID ($performedStudyInsUID) in MPPS ($mppsFile) message does not match\n";
      print main::LOG "ERR: Scheduled Study Ins UID ($scheduledStudyInsUID) in HL7 scheduling message $testORM\n";
      print main::LOG "ERR: For this scheduling message after the procedure, the DSS/OF\n";
      print main::LOG "ERR:  is supposed to use the value provided in the MPPS message.\n";
      $errorCount += 1;
    }
  } else {
    print main::LOG "ERR: Could not get Study Instance UID from $mppsFile (0040 0270 0020 000D)\n";
    print main::LOG "ERR: This is a MESA bug; please log a bug report\n";
    $errorCount += 1;
  }

  return $errorCount;
}

sub evaluate_ADT_A04 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A04 $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  # PID 3, Patient ID List
  my $patientID =     mesa::getField($testADT, "PID", "3", "0", "Patient ID");
  #my $mesaPatientID = mesa::getField($mesaADT, "PID", "3", "0", "Patient ID");
  $len = length ($patientID);
  print main::LOG "CTX: PID  3 Patient ID List:          $patientID, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  3: Patient ID List should not be zero length\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID  3: Patient ID List length is constrained to 20 characters\n";
    print main::LOG "ERR: PID  3: Your patient ID length is $len\n";
    print main::LOG "ERR: Test value: $patientID\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 5, Patient Name
  my $patientName =     mesa::getField($testADT, "PID", "5", "0", "Patient Name");
  my $mesaPatientName = mesa::getField($mesaADT, "PID", "5", "0", "Patient Name");
  $len = length ($patientName);
  print main::LOG "CTX: PID  5 Patient Name:             $patientName, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  5: Patient Name should not be zero length\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientName ne $mesaPatientName) {
    print main::LOG "ERR: PID  5: Patient Name from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientName\n";
    print main::LOG "ERR: MESA value: $mesaPatientName\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 8, Patient Sex
  my $patientSex =     mesa::getField($testADT, "PID", "8", "0", "Patient Sex");
  my $mesaPatientSex = mesa::getField($mesaADT, "PID", "8", "0", "Patient Sex");
  $len = length ($patientSex);
  print main::LOG "CTX: PID  8 Patient Sex:              $patientSex, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  8: Patient Sex should not be zero length\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientSex ne $mesaPatientSex) {
    print main::LOG "ERR: PID  8: Patient Sex from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientSex\n";
    print main::LOG "ERR: MESA value: $mesaPatientSex\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 10, Patient Race
  my $patientRace =     mesa::getField($testADT, "PID", "10", "0", "Patient Race");
  my $mesaPatientRace = mesa::getField($mesaADT, "PID", "10", "0", "Patient Race");
  $len = length ($patientRace);
  print main::LOG "CTX: PID 10 Patient Race:             $patientRace, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 10: Patient Race should not be zero length\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientRace ne $mesaPatientRace) {
    print main::LOG "ERR: PID 10: Patient Race from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientRace\n";
    print main::LOG "ERR: MESA value: $mesaPatientRace\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 11, Patient Address
  my $patientAddress =     mesa::getField($testADT, "PID", "11", "0", "Patient Address");
  my $mesaPatientAddress = mesa::getField($mesaADT, "PID", "11", "0", "Patient Address");
  $len = length ($patientAddress);
  print main::LOG "CTX: PID 11 Patient Address:          $patientAddress, length: $len\n" if ($logLevel >= 3);

  if ($patientAddress eq $mesaPatientAddress) {
    # That means they got everything right
  } elsif ($len == 0) {
    print main::LOG "ERR: PID 11: Patient Address should not be zero length\n";
    print main::LOG "ERR: PID 11: MESA Patient Address is $mesaPatientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 106) {
    print main::LOG "ERR: PID 11: Patient Address length is constrained to 106 characters\n";
    print main::LOG "ERR: PID 11: Your Patient Address length is $len\n";
    print main::LOG "ERR: Test value: $patientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } else {
    print main::LOG "WARN: PID 11: Patient Address does not match MESA address\n";
    print main::LOG "WARN: PID 11: We assume this is a typo and mark this as a warning\n";
    print main::LOG "WARN: Test value: $patientAddress\n";
    print main::LOG "WARN: MESA value: $mesaPatientAddress\n";
  }

  # PID 18, Patient Account Number
  my $patientAccountNumber =     mesa::getField($testADT, "PID", "18", "0", "Patient Account Number");
  #my $mesaPatientAccountNumber = mesa::getField($mesaADT, "PID", "18", "0", "Patient Account Number");
  $len = length ($patientAccountNumber);
  print main::LOG "CTX: PID 18 Patient Account Number:   $patientAccountNumber, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 18: Patient Account Number should not be zero length\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID 18: Patient Account Number length is constrained to 20 characters\n";
    print main::LOG "ERR: PID 18: Your Patient Account Number length is $len\n";
    print main::LOG "ERR: Test value: $patientAccountNumber\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 2, Patient Class
  my $patientClass = mesa::getField($testADT, "PV1", "2", "0", "Patient Class");
  my $mesaPatientClass = mesa::getField($mesaADT, "PV1", "2", "0", "Patient Class");
  $len = length ($patientClass);
  print main::LOG "CTX: PV1  2 Patient Class:            $patientClass, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  2: Patient Class should not be zero length\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.1-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientClass ne $mesaPatientClass) {
    print main::LOG "ERR: PV1  2: Patient class from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientClass\n";
    print main::LOG "ERR: MESA value: $mesaPatientClass\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.1-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 7, Attending doctor
  my $attendingDoctor = mesa::getField($testADT, "PV1", "7", "0", "Attending doctor");
  my $mesaAttendingDoctor = mesa::getField($mesaADT, "PV1", "7", "0", "Attending doctor");
  $len = length ($attendingDoctor);
  print main::LOG "CTX: PV1  7 Attending Doctor:         $attendingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1  7: Attending doctor in your A04 messages should be zero length\n";
    print main::LOG "ERR: Test value: $attendingDoctor\n";
    print main::LOG "REF: PV1  7: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAttendingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 7 Attending doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 8, Referring doctor
  my $referringDoctor =     mesa::getField($testADT, "PV1", "8", "0", "Referring Doctor");
  my $mesaReferringDoctor = mesa::getField($mesaADT, "PV1", "8", "0", "ReferringDoctor");
  $len = length ($referringDoctor);
  print main::LOG "CTX: PV1  8 Referring Doctor:         $referringDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  8: Referring Doctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($referringDoctor ne $mesaReferringDoctor) {
    print main::LOG "ERR: PV1  8: Referring Doctor from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $referringDoctor\n";
    print main::LOG "ERR: MESA value: $mesaReferringDoctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 17, Admitting doctor
  my $admittingDoctor =     mesa::getField($testADT, "PV1", "17", "0", "Admitting doctor");
  my $mesaAdmittingDoctor = mesa::getField($mesaADT, "PV1", "17", "0", "Admitting doctor");
  $len = length ($admittingDoctor);
  print main::LOG "CTX: PV1 17 Admitting Doctor:         $admittingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1 17: Admitting Doctor in your A04 messages should be zero length\n";
    print main::LOG "ERR: Test value: $admittingDoctor\n";
    print main::LOG "REF: PV1 17: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAdmittingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 17 Admitting doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 19, Visit Number and PID 18 Account Number
  my $visitNumber =         mesa::getField($testADT, "PV1", "19", "0", "Visit Number");
  my $accountNumber =       mesa::getField($testADT, "PID", "18", "0", "Account Number");
  print main::LOG "CTX: PV1 19 Visit Number:             $visitNumber\n" if ($logLevel >= 3);
  print main::LOG "CTX: PID 18 Account Number:           $accountNumber\n" if ($logLevel >= 3);
  if (($visitNumber eq "") && ($accountNumber eq "")) {
    print main::LOG "ERR: Both PV1 19 (Visit Number) and PID 18 (Account Number) are 0 length\n";
    print main::LOG "REF: PV1 18: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  return $errorCount;
}

sub evaluate_ADT_A08 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A08 $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  # PID 3, Patient ID List
  my $patientID =     mesa::getField($testADT, "PID", "3", "0", "Patient ID");
  #my $mesaPatientID = mesa::getField($mesaADT, "PID", "3", "0", "Patient ID");
  $len = length ($patientID);
  print main::LOG "CTX: PID  3 Patient ID List:          $patientID, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  3: Patient ID List should not be zero length\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID  3: Patient ID List length is constrained to 20 characters\n";
    print main::LOG "ERR: PID  3: Your patient ID length is $len\n";
    print main::LOG "ERR: Test value: $patientID\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 5, Patient Name
  my $patientName =     mesa::getField($testADT, "PID", "5", "0", "Patient Name");
  my $mesaPatientName = mesa::getField($mesaADT, "PID", "5", "0", "Patient Name");
  $len = length ($patientName);
  print main::LOG "CTX: PID  5 Patient Name:             $patientName, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  5: Patient Name should not be zero length\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientName ne $mesaPatientName) {
    print main::LOG "ERR: PID  5: Patient Name from your A08 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientName\n";
    print main::LOG "ERR: MESA value: $mesaPatientName\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 8, Patient Sex
  my $patientSex =     mesa::getField($testADT, "PID", "8", "0", "Patient Sex");
  my $mesaPatientSex = mesa::getField($mesaADT, "PID", "8", "0", "Patient Sex");
  $len = length ($patientSex);
  print main::LOG "CTX: PID  8 Patient Sex:              $patientSex, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  8: Patient Sex should not be zero length\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientSex ne $mesaPatientSex) {
    print main::LOG "ERR: PID  8: Patient Sex from your A08 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientSex\n";
    print main::LOG "ERR: MESA value: $mesaPatientSex\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 10, Patient Race
  my $patientRace =     mesa::getField($testADT, "PID", "10", "0", "Patient Race");
  my $mesaPatientRace = mesa::getField($mesaADT, "PID", "10", "0", "Patient Race");
  $len = length ($patientRace);
  print main::LOG "CTX: PID 10 Patient Race:             $patientRace, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 10: Patient Race should not be zero length\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientRace ne $mesaPatientRace) {
    print main::LOG "ERR: PID 10: Patient Race from your A08 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientRace\n";
    print main::LOG "ERR: MESA value: $mesaPatientRace\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 11, Patient Address
  my $patientAddress =     mesa::getField($testADT, "PID", "11", "0", "Patient Address");
  my $mesaPatientAddress = mesa::getField($mesaADT, "PID", "11", "0", "Patient Address");
  $len = length ($patientAddress);
  print main::LOG "CTX: PID 11 Patient Address:          $patientAddress, length: $len\n" if ($logLevel >= 3);

  if ($patientAddress eq $mesaPatientAddress) {
    # That means they got everything right
  } elsif ($len == 0) {
    print main::LOG "ERR: PID 11: Patient Address should not be zero length\n";
    print main::LOG "ERR: PID 11: MESA Patient Address is $mesaPatientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 106) {
    print main::LOG "ERR: PID 11: Patient Address length is constrained to 106 characters\n";
    print main::LOG "ERR: PID 11: Your Patient Address length is $len\n";
    print main::LOG "ERR: Test value: $patientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } else {
    print main::LOG "WARN: PID 11: Patient Address does not match MESA address\n";
    print main::LOG "WARN: PID 11: We assume this is a typo and mark this as a warning\n";
    print main::LOG "WARN: Test value: $patientAddress\n";
    print main::LOG "WARN: MESA value: $mesaPatientAddress\n";
  }

  # PID 18, Patient Account Number
  my $patientAccountNumber =     mesa::getField($testADT, "PID", "18", "0", "Patient Account Number");
  #my $mesaPatientAccountNumber = mesa::getField($mesaADT, "PID", "18", "0", "Patient Account Number");
  $len = length ($patientAccountNumber);
  print main::LOG "CTX: PID 18 Patient Account Number:   $patientAccountNumber, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 18: Patient Account Number should not be zero length\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID 18: Patient Account Number length is constrained to 20 characters\n";
    print main::LOG "ERR: PID 18: Your Patient Account Number length is $len\n";
    print main::LOG "ERR: Test value: $patientAccountNumber\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.12-5\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 2, Patient Class
  my $patientClass = mesa::getField($testADT, "PV1", "2", "0", "Patient Class");
  my $mesaPatientClass = mesa::getField($mesaADT, "PV1", "2", "0", "Patient Class");
  $len = length ($patientClass);
  print main::LOG "CTX: PV1  2 Patient Class:            $patientClass, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  2: Patient Class should not be zero length\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.12-6\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientClass ne $mesaPatientClass) {
    print main::LOG "ERR: PV1  2: Patient class from your A08 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientClass\n";
    print main::LOG "ERR: MESA value: $mesaPatientClass\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.12-6\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 7, Attending doctor
  my $attendingDoctor = mesa::getField($testADT, "PV1", "7", "0", "Attending doctor");
  my $mesaAttendingDoctor = mesa::getField($mesaADT, "PV1", "7", "0", "Attending doctor");
  $len = length ($attendingDoctor);
  print main::LOG "CTX: PV1  7 Attending Doctor:         $attendingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1  7: Attending doctor in your A08 messages should be zero length\n";
    print main::LOG "ERR: Test value: $attendingDoctor\n";
    print main::LOG "REF: PV1  7: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAttendingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 7 Attending doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 8, Referring doctor
  my $referringDoctor =     mesa::getField($testADT, "PV1", "8", "0", "Referring Doctor");
  my $mesaReferringDoctor = mesa::getField($mesaADT, "PV1", "8", "0", "ReferringDoctor");
  $len = length ($referringDoctor);
  print main::LOG "CTX: PV1  8 Referring Doctor:         $referringDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  8: Referring Doctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($referringDoctor ne $mesaReferringDoctor) {
    print main::LOG "ERR: PV1  8: Referring Doctor from your A08 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $referringDoctor\n";
    print main::LOG "ERR: MESA value: $mesaReferringDoctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 17, Admitting doctor
  my $admittingDoctor =     mesa::getField($testADT, "PV1", "17", "0", "Admitting doctor");
  my $mesaAdmittingDoctor = mesa::getField($mesaADT, "PV1", "17", "0", "Admitting doctor");
  $len = length ($admittingDoctor);
  print main::LOG "CTX: PV1 17 Admitting Doctor:         $admittingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1 17: Admitting Doctor in your A08 messages should be zero length\n";
    print main::LOG "ERR: Test value: $admittingDoctor\n";
    print main::LOG "REF: PV1 17: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAdmittingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 17 Admitting doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 19, Visit Number and PID 18 Account Number
  my $visitNumber =         mesa::getField($testADT, "PV1", "19", "0", "Visit Number");
  my $accountNumber =       mesa::getField($testADT, "PID", "18", "0", "Account Number");
  print main::LOG "CTX: PV1 19 Visit Number:             $visitNumber\n" if ($logLevel >= 3);
  print main::LOG "CTX: PID 18 Account Number:           $accountNumber\n" if ($logLevel >= 3);
  if (($visitNumber eq "") && ($accountNumber eq "")) {
    print main::LOG "ERR: Both PV1 19 (Visit Number) and PID 18 (Account Number) are 0 length\n";
    print main::LOG "REF: PV1 18: See TF Vol II, Table 4.12-5, Table 4.12-6 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  return $errorCount;
}

# This function evaluates A40 merge messages sent by a DSS/OF
# when merging a temporary DSS identifier with a permanent identifier.
sub evaluate_ADT_A40_DSS_TempID {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A40_DSS_TempID $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "0",  "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"MRG", " 1", "0",  "20", "Prior Patient ID List  ", "Rad TF 2: ",
	"MRG", " 4", "0",  "20", "Prior Patient ID       ", "Rad TF 2: ",
  );

  print main::LOG "CTX: Testing for fields that should not be 0-length\n";
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $subComp   = $nonZeroFields[$idx+2];
    my $maxLen    = $nonZeroFields[$idx+3];
    my $fieldName = $nonZeroFields[$idx+4];
    my $reference = $nonZeroFields[$idx+5];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "ERR: Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "ERR: File name is $testADT\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

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
    $idx += 6;
  }

  @equivalentFields = (
	"MSH", " 1", "0", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "0", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "0", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "0", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "0", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "0", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "0", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "0", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", "0", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "0", " 48", "Patient ID             ", "TF Vol II, Table ",
	"PID", " 5", "0", " 48", "Patient Name           ", "TF Vol II, Table ",
  );

  print main::LOG "CTX: Testing for fields that should match a specific value\n";
  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $subComp   = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testADT, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testADT\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaADT, $segment, $field, $subComp, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaADT\n";
      return 1;		# Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field.$subComp $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

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

  return $errorCount
}

sub evaluate_BAR_P01 {
  my ($logLevel, $mesaBAR, $testBAR) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_BAR_P01 $mesaBAR $testBAR\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "20", "Patient Identifier List", "TF Vol III, Table 4.36-1",
	"PID", "18", "20", "Patient Account Number ", "TF Vol III, Table 4.36-1",
	"DG1", " 1", " 4", "Set ID - DG1           ", "TF Vol III, Table 4.36-2",
	"GT1", " 1", " 4", "Set ID - GT1           ", "TF Vol III, Table 4.36-3",
	"IN1", " 1", " 4", "Set ID - IN1           ", "TF Vol III, Table 4.36-4",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
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
	"MSH", " 1", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 5", " 48", "Patient Name           ", "TF Vol III, Table 4.36-1",
	"DG1", " 6", "  2", "Diagnosis Type         ", "TF Vol III, Table 4.36-2",
	"GT1", " 3", " 48", "Guarantor Name         ", "TF Vol III, Table 4.36-3",
	"IN1", " 2", " 60", "Insurance Plan ID      ", "TF Vol III, Table 4.36-4",
	"IN1", " 3", " 59", "Insurance Company ID   ", "TF Vol III, Table 4.36-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $maxLen    = $equivalentFields[$idx+2];
    my $fieldName = $equivalentFields[$idx+3];
    my $reference = $equivalentFields[$idx+4];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaBAR\n";
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
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 5;
  }

  return $errorCount
}

sub evaluate_BAR_P05 {
  my ($logLevel, $mesaBAR, $testBAR) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_BAR_P05 $mesaBAR $testBAR\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "20", "Patient Identifier List", "TF Vol III, Table 4.36-1",
	"PID", "18", "20", "Patient Account Number ", "TF Vol III, Table 4.36-1",
	"DG1", " 1", " 4", "Set ID - DG1           ", "TF Vol III, Table 4.36-2",
	"GT1", " 1", " 4", "Set ID - GT1           ", "TF Vol III, Table 4.36-3",
	"IN1", " 1", " 4", "Set ID - IN1           ", "TF Vol III, Table 4.36-4",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
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
	"MSH", " 1", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 5", " 48", "Patient Name           ", "TF Vol III, Table 4.36-1",
	"DG1", " 6", "  2", "Diagnosis Type         ", "TF Vol III, Table 4.36-2",
	"GT1", " 3", " 48", "Guarantor Name         ", "TF Vol III, Table 4.36-3",
	"IN1", " 2", " 60", "Insurance Plan ID      ", "TF Vol III, Table 4.36-4",
	"IN1", " 3", " 59", "Insurance Company ID   ", "TF Vol III, Table 4.36-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $maxLen    = $equivalentFields[$idx+2];
    my $fieldName = $equivalentFields[$idx+3];
    my $reference = $equivalentFields[$idx+4];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaBAR\n";
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
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 5;
  }

  return $errorCount
}

sub evaluate_BAR_P06 {
  my ($logLevel, $mesaBAR, $testBAR) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_BAR_P06 $mesaBAR $testBAR\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"PID", " 3", "20", "Patient Identifier List", "TF Vol III, Table 4.36-1",
	"PID", "18", "20", "Patient Account Number ", "TF Vol III, Table 4.36-1",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
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
	"MSH", " 1", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"PID", " 5", " 48", "Patient Name           ", "TF Vol III, Table 4.36-1",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $maxLen    = $equivalentFields[$idx+2];
    my $fieldName = $equivalentFields[$idx+3];
    my $reference = $equivalentFields[$idx+4];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testBAR\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaBAR, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaBAR\n";
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
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 5;
  }

  return $errorCount
}

sub evaluate_ORM_O01_Status {
  my ($logLevel, $mesaORM, $testORM) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ORM_O01_Status $mesaORM $testORM\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "TF Vol II, Table 2.4-1",
	"ORC", " 3", "22", "Filler Order Number    ", "TF Vol II, Table 4.3-5",
  );

  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
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
	"MSH", " 1", "  1", "Field Separator        ", "TF Vol II, Table 2.4-1",
	"MSH", " 2", "  4", "Encoding Characters    ", "TF Vol II, Table 2.4-1",
	"MSH", " 3", "180", "Sending Application    ", "TF Vol II, Table 2.4-1",
	"MSH", " 4", "180", "Sending Facility       ", "TF Vol II, Table 2.4-1",
	"MSH", " 5", "180", "Receiving Application  ", "TF Vol II, Table 2.4-1",
	"MSH", " 6", "180", "Receiving Facility     ", "TF Vol II, Table 2.4-1",
	"MSH", " 9", "  7", "Message Type           ", "TF Vol II, Table 2.4-1",
	"MSH", "11", "  3", "Processing ID          ", "TF Vol II, Table 2.4-1",
	"MSH", "12", " 60", "Version ID             ", "TF Vol II, Table 2.4-1",
	"ORC", " 1", "  2", "Order Control          ", "TF Vol II, Table 4.3-5",
	"ORC", " 2", " 22", "Placer Order Number    ", "TF Vol II, Table 4.3-5",
	"ORC", " 5", "  2", "Order Status           ", "TF Vol II, Table 4.3-5",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $maxLen    = $equivalentFields[$idx+2];
    my $fieldName = $equivalentFields[$idx+3];
    my $reference = $equivalentFields[$idx+4];

    ($status, $vTest) = mesa::getHL7Field($logLevel, $testORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testORM\n";
      return 1;		# Non-zero error count
    }
    ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaORM, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaORM\n";
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
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 5;
  }

  return $errorCount
}

sub evaluate_one_mwl_resp {
  my ($logLevel, $testFile, $stdFile) = @_;

  my $evalString = "$main::MESA_TARGET/bin/cfind_mwl_evaluate " .
     " -l $logLevel " .
     " $testFile $stdFile";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);
  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_one_mwl_resp_eye_care {
  my ($logLevel, $testFile, $stdFile) = @_;

  ($status, $issuerMESA) = mesa::getDICOMAttribute($logLevel, $stdFile, "0010 0021");
  ($status, $issuerTest) = mesa::getDICOMAttribute($logLevel, $testFile, "0010 0021");
  if ($logLevel >= 3) {
    print main::LOG "CTX: MWL 0010 0021 Issuer of ID Test: $issuerTest\n";
    print main::LOG "CTX: MWL 0010 0021 Issuer of ID MESA: $issuerMESA\n";
  }
  return 1 if ($issuerTest ne $issuerMESA);

  return 0;
}

sub evaluate_one_mwl_resp_card_mpps_trigger_no_order {
  my ($logLevel, $testFile, $stdFile, $mppsTrigger) = @_;

  print main::LOG "CTX: mesa::evaluate_one_mwl_resp_card_mpps_trigger_no_order\n" if ($logLevel >= 3);
  print main::LOG "CTX: MPPS Trigger file: $mppsTrigger\n" if ($logLevel >= 3);

  my $status = 0;
  my $studyInsUIDMESA = 0;
  ($status, $studyInsUIDMESA) = mesa::getDICOMAttribute($logLevel, $mppsTrigger, "0020 000d", "0040 0270");
  if ($status != 0) {
    print main::LOG "ERR: Could not get MESA Study Instance UID from $mppsTrigger\n";
    return 1;
  }
  ($status, $studyInsUIDTest) = mesa::getDICOMAttribute($logLevel, $testFile, "0020 000d");
  if ($status != 0) {
    print main::LOG "ERR: Could not get MESA Study Instance UID from MWL file $testFile\n";
    return 1;
  }

  print main::LOG "CTX: MPPS Study Ins UID: $studyInsUIDMESA\n" if ($logLevel >= 3);
  print main::LOG "CTX:  MWL Study Ins UID: $studyInsUIDTest\n" if ($logLevel >= 3);

  if ($studyInsUIDMESA ne $studyInsUIDTest) {
    print main::LOG "ERR: MWL Study Ins UID does not equal Study Instance UID from MPPS trigger\n";
    print main::LOG "ERR: MPPS Study Ins UID: $studyInsUIDMESA\n";
    print main::LOG "ERR:  MWL Study Ins UID: $studyInsUIDTest\n";
    return 1;
  }

  return 0;
}

sub evaluate_mpps_mpps_mgr {
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
	" -l $logLevel " .
	" mgr $testNumber $storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub compareAttribute {
  my ($logLevel, $tag, $stdFile, $testFile) = @_;

  my $x = "$main::MESA_TARGET/bin/dcm_print_element $tag $stdFile";
  my $stdVal = `$x`; chomp $stdVal;

  my $y = "$main::MESA_TARGET/bin/dcm_print_element $tag $testFile";
  my $testVal = `$y`; chomp $testVal;

  print main::LOG "CTX: $tag <S:T> <$stdVal><$testVal>\n" if ($logLevel >= 3);
  return 0 if ($stdVal eq $testVal);

  print main::LOG "ERR: Attr value differs for $tag <S:T> <$stdVal><$testVal>\n";
  return 1;
}

sub compareSequenceAttribute {
  my ($logLevel, $seqTag, $tag, $stdFile, $testFile) = @_;

  my $x = "$main::MESA_TARGET/bin/dcm_print_element -s $seqTag $tag $stdFile";
  my $stdVal = `$x`; chomp $stdVal;

  my $y = "$main::MESA_TARGET/bin/dcm_print_element -s $seqTag $tag $testFile";
  my $testVal = `$y`; chomp $testVal;

  print main::LOG "CTX: ($seqTag) $tag <S:T> <$stdVal><$testVal>\n" if ($logLevel >= 3);
  return 0 if ($stdVal eq $testVal);

  print main::LOG "ERR: Attr value differs for ($seqTag) $tag <S:T> <$stdVal><$testVal>\n";
  return 1;
}

sub compareSequenceAttributeLevel2 {
  my ($logLevel, $seqTag0, $seqTag1, $tag, $stdFile, $testFile) = @_;

  my $x = "$main::MESA_TARGET/bin/dcm_print_element -z $seqTag0 $seqTag1 $tag $stdFile";
  my $stdVal = `$x`; chomp $stdVal;

  my $y = "$main::MESA_TARGET/bin/dcm_print_element -z $seqTag0 $seqTag1 $tag $testFile";
  my $testVal = `$y`; chomp $testVal;

  print main::LOG "CTX: ($seqTag0 $seqTag1) $tag <S:T> <$stdVal><$testVal>\n" if ($logLevel >= 3);
  return 0 if ($stdVal eq $testVal);

  print main::LOG "ERR: Attr value differs for ($seqTag) $tag <S:T> <$stdVal><$testVal>\n";
  return 1;
}

#sub evaluate_gppps_rpt_mgr {
#  my ($logLevel, $stdDir, $storageDir, $testNumber) = @_;
#
#  if (! -e($storageDir)) {
#    print main::LOG "ERR: MESA storage directory does not exist \n";
#    print main::LOG "ERR:  Directory is expected to be: $storageDir \n";
#    print main::LOG "ERR:  Did you invoke the evaluation script with the proper AE title? \n";
#    return 1;
#  }
#
#  if (! open(GPPPS_HANDLE, "< $stdDir/gppps_uid.txt")) {
#    print main::LOG "ERR: Could not open GPPPS UID File: $stdDir/gppps_uid.txt\n";
#    return 1;
#  }
#
#  $gppps_UID = <GPPPS_HANDLE>;
#  chomp $gppps_UID;
#  print main::LOG "CTX: GPPPS UID = $gppps_UID \n" if ($logLevel >= 3);
#
#  if (! -e("$storageDir/$gppps_UID")) {
#    print main::LOG "ERR: MESA GPPPS directory does not exist \n";
#    print main::LOG "ERR:  Directory is expected to be: $storageDir/$gppps_UID \n";
#    print main::LOG "ERR:  This implies you did not send GPPPS messages for these GPPPS events.\n";
#    return 1;
#  }
#
#  if (! -e("$storageDir/$gppps_UID/gppps.dcm")) {
#    print main::LOG "ERR: GPPPS status file does not exist \n";
#    print main::LOG "ERR:  File is expected to be: $storageDir/$gppps_UID/gppps.dcm \n";
#    print main::LOG "ERR:  This implies a problem in the MESA software because the directory exists but the file is missing.\n";
#    return 1;
#  }
#
#  if (! -e("$stdDir/gppps.status")) {
#    print main::LOG "ERR: GPPPS status file does not exist \n";
#    print main::LOG "ERR:  File is expected to be: $stdDir/gppps.status \n";
#    print main::LOG "ERR:  This implies a problem in the MESA software.\n";
#    print main::LOG "ERR:  Please log a bug report.\n";
#    return 1;
#  }
#
#  $rtnValue = 0;
#
#  @topLevelTags = (
#	"0010 0010",		# Patient Name
#	"0010 0020",		# Patient ID
#	"0010 0030",		# Patient DOB
#	"0010 0040",		# Patient Sex
#  );
#  foreach $tag(@topLevelTags) {
#    $x = mesa::compareAttribute(
#	$logLevel,
#	$tag,
#	"$stdDir/gppps.status",
#	"$storageDir/$gppps_UID/gppps.dcm");
#    $rtnValue = 1 if ($x != 0);
#  }
#
#  # General Purpose PPS Relationship
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 A370", "0020 000D",		# Study Instance UID
#	"$stdDir/gppps.status",
#	"$storageDir/$gppps_UID/gppps.dcm");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 A370", "0008 0050",		# Accession Number
#	"$stdDir/gppps.status",
#	"$storageDir/$gppps_UID/gppps.dcm");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 A370", "0040 1001",		# Requested Procedure ID
#	"$stdDir/gppps.status",
#	"$storageDir/$gppps_UID/gppps.dcm");
#  $rtnValue = 1 if ($x != 0);
#  return $rtnValue;
#}

sub find_workitem_status_by_ref_sop_instance {
  my ($logLevel, $storageDir, $sopInstanceUID) = @_;

  opendir STORAGE, $storageDir or return (1, "");
  @gpppsDirs = readdir STORAGE;
  closedir STORAGE;

E: foreach $d (@gpppsDirs) {
    next E if ($d eq "." || $d eq "..");
    print main::LOG "CTX: $storageDir " if ($logLevel >= 3);
    next E if (! -e("$storageDir/$d/gppps.dcm"));
    my ($status, $uid) = mesa::getDICOMAttribute($logLevel, "$storageDir/$d/gppps.dcm", "0008 1155", "0040 4016");
    return (1, "") if ($status != 0);
    print main::LOG "$uid \n";
    return (0, "$storageDir/$d/gppps.dcm") if ($uid eq $sopInstanceUID);
  }

  return (1, "");
}

sub find_gppps_by_performed_workitem_code {
  my ($logLevel, $storageDir, $workitemCode) = @_;

  opendir STORAGE, $storageDir or return (1, "");
  @gpppsDirs = readdir STORAGE;
  closedir STORAGE;

E: foreach $d (@gpppsDirs) {
    next E if ($d eq "." || $d eq "..");
    print main::LOG "CTX: $storageDir " if ($logLevel >= 3);
    next E if (! -e("$storageDir/$d/gppps.dcm"));
    my ($status, $code) = mesa::getDICOMAttribute($logLevel, "$storageDir/$d/gppps.dcm", "0008 0100", "0040 4019");
    return (1, "") if ($status != 0);
    print main::LOG "$code \n" if ($logLevel >= 3);
    return (0, "$storageDir/$d/gppps.dcm") if ($code eq $workitemCode);
  }

  return (1, "");
}

sub evaluate_gppps_workitem_status {
  my ($logLevel, $stdDir, $storageDirTest, $storageDirMESA, $testNumber) = @_;

  if (! -e($storageDirTest)) {
    print main::LOG "ERR:  Storage directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDirTest \n";
    print main::LOG "ERR:  Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  if (! -e($storageDirMESA)) {
    print main::LOG "ERR:  Storage directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDirMESA \n";
    print main::LOG "ERR:  This is a MESA software bug; please log a bug report\n";
    return 1;
  }

  my ($a, $sopInstanceUID) = mesa::getDICOMAttribute($logLevel, "$stdDir/gppps.crt", "0008 1155", "0040 4016");
  if ($a != 0) {
    print main::LOG "ERR: Could not get Referenced GPPPPS Seq/Referenced SOP Instance UID from $stdDir/gppps.crt \n";
    return 1;
  }

  my ($x, $gpppsFileTest) = mesa::find_workitem_status_by_ref_sop_instance (
	$logLevel, $storageDirTest, $sopInstanceUID);
  if ($x != 0) {
    print main::LOG "ERR: Could not find a GPPPS item in $storageDirTest for " .
		    "Referenced GPPPPS Seq/Referenced SOP Instance UID $sopInstanceUID \n";
    return 1;
  }

  my ($y, $gpppsFileMESA) = mesa::find_workitem_status_by_ref_sop_instance (
	$logLevel, $storageDirMESA, $sopInstanceUID);
  if ($y != 0) {
    print main::LOG "ERR: Could not find a GPPPS item in $storageDirMESA for " .
		    "Referenced GPPPPS Seq/Referenced SOP Instance UID $sopInstanceUID \n";
    print main::LOG "This is a MESA programming error; please log a bug report.\n";
    return 1;
  }

  $rtnValue = 0;
  # General Purpose PPS Relationship
  print main::LOG "CTX: <S:T> <$gpppsFileMESA><$gpppsFileTest> \n";
  print main::LOG "CTX: General Purpose PPS Relationship\n";
  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0020 000D",		# Study Instance UID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

#  $x = mesa::compareSequenceAttributeLevel2(
#	$logLevel,
#	"0040 A370", "0008 1110", "0008 1155",	# Referenced SOP Instance UID
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0008 0050",		# Accession Number
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring (0040 A370) 0032 1064 Requested Procedure Code Sequence\n";
  print main::LOG "CTX: Ignoring (0040 A370) 0040 2016 Placer Order Number/Imaging Service Request\n";
  print main::LOG "CTX: Ignoring (0040 A370) 0040 2017 Filler Order Number/Imaging Service Request\n";

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0040 1001",		# Requested Procedure ID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4016", "0008 1150",		# REf GPPPS Sequence / Refe SOP Class UID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4016", "0008 1155",		# REf GPPPS Sequence / Refe SOP Instance UID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  ($x, $transUID) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 4023", "0040 4016");
  if ($x == 1 || $transUID eq "") {
    print main::LOG "ERR: Unable to get Ref GPPPS Transaction UID from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: (0040 4023) 0040 4016 Ref GPPPS Trans UID <$transUID>\n";
  }

  @topLevelTags = (
	"0010 0010",		# Patient Name
	"0010 0020",		# Patient ID
	"0010 0030",		# Patient DOB
	"0010 0040",		# Patient Sex
  );
  foreach $tag(@topLevelTags) {
    $x = mesa::compareAttribute(
	$logLevel,
	$tag,
	"$gpppsFileMESA",
	"$gpppsFileTest");
    $rtnValue = 1 if ($x != 0);
  }

  # General Purpose Performed Procedure Step Information
  print main::LOG "CTX: General Purpose PPS Information\n";
  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0100",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0102",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0104",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  ($x, $ppsID) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0253");
  if ($x == 1 || $ppsID eq "") {
    print main::LOG "ERR: Unable to get PPS ID (0040 0253) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: (0040 0253) PPS ID <$ppsID>\n";
  }

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0100", # Performed Station Name Code Sequence
				  # -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0102", # Performed Station Name Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0104", # Performed Station Name Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring 0040 4007 Performed Processing Applications Code Sequence\n";
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0100", # Performed Processing Applications Code Sequence
#				  # -> Code Value
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0102", # Performed Processing Applications Code Sequence
#				  # -> Coding Scheme Designator
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0104", # Performed Processing Applications Code Sequence
#				  # -> Code Meaning
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);

  ($x, $ppsStartDate) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0244");
  if ($x == 1 || $ppsStartDate eq "") {
    print main::LOG "ERR: Unable to get PPS Start Date (0040 0244) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0244 PPS Start Date <$ppsStartDate>\n";
  }

  ($x, $ppsStartTime) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0245");
  if ($x == 1 || $ppsStartTime eq "") {
    print main::LOG "ERR: Unable to get PPS Start Time (0040 0245) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0245 PPS Start Time <$ppsStartTime>\n";
  }

  $x = mesa::compareAttribute(
	$logLevel,
	"0040 4002",		# GP-PPS Status
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring 0040 0254 Performed Procedure Step Description\n" if ($logLevel >= 3);
  print main::LOG "CTX: Ignoring 0040 0280 Comments on the Performed Procedure Step\n" if ($logLevel >= 3);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0100", # Performed Workitem Code Sequence
				  # -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0102", # Performed Workitem Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0104", # Performed Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  ($x, $ppsEndDate) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0250");
  if ($x == 1 || $ppsEndDate eq "") {
    print main::LOG "ERR: Unable to get PPS End Date (0040 0250) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0250 PPS End Date <$ppsEndDate>\n";
  }

  ($x, $ppsEndTime) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0251");
  if ($x == 1 || $ppsEndTime eq "") {
    print main::LOG "ERR: Unable to get PPS End Time (0040 0251) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0251 PPS End Time <$ppsEndTime>\n";
  }

  # General Purpose Results
  print main::LOG "CTX: General Purpose Results\n";
  print main::LOG "CTX: Ignoring 0040 4033 Output Information Sequence\n";

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0100", # Requested Subsequence Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0102", # Requested Subsequence Workitem Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0104", # Requested Subsequence Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  return $rtnValue;
}

sub evaluate_gppps_performed_work_status {
  my ($logLevel, $stdDir, $storageDirTest, $storageDirMESA, $testNumber) = @_;

  if (! -e($storageDirTest)) {
    print main::LOG "ERR:  Storage directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDirTest \n";
    print main::LOG "ERR:  Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  if (! -e($storageDirMESA)) {
    print main::LOG "ERR:  Storage directory does not exist \n";
    print main::LOG "ERR:  Directory is expected to be: $storageDirMESA \n";
    print main::LOG "ERR:  This is a MESA software bug; please log a bug report\n";
    return 1;
  }

  my ($a, $performedCode) = mesa::getDICOMAttribute($logLevel, "$stdDir/gppps.crt", "0008 0100", "0040 4019");
  if ($a != 0 || $performedCode eq "") {
    print main::LOG "ERR: Could not get Performed Workitem Code Sequence->Code Valuefrom $stdDir/gppps.status \n";
    print main::LOG "ERR: This is a MESA software bug; please log a bug report.\n";
    return 1;
  }
  print main::LOG "CTX: Performed workitem code (0040 4019) 0008 0100 <$performedCode>\n"
	if ($logLevel >= 3);

  my ($x, $gpppsFileTest) = mesa::find_gppps_by_performed_workitem_code (
	$logLevel, $storageDirTest, $performedCode);
  if ($x != 0) {
    print main::LOG "ERR: Could not find a GPPPS item in $storageDirTest for " .
		    "Performed workitem code <$performedCode> \n";
    return 1;
  }

  my ($y, $gpppsFileMESA) = mesa::find_gppps_by_performed_workitem_code (
	$logLevel, $storageDirMESA, $performedCode);
  if ($y != 0) {
    print main::LOG "ERR: Could not find a GPPPS item in $storageDirMESA for " .
		    "Performed workitem code <$performedCode> \n";
    print main::LOG "This is a MESA programming error; please log a bug report.\n";
    return 1;
  }

  $rtnValue = 0;
  print main::LOG "CTX: <S:T> <$gpppsFileMESA><$gpppsFileTest> \n";
  # General Purpose PPS Relationship
  print main::LOG "CTX: General Purpose PPS Relationship\n";
  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0020 000D",		# Study Instance UID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring (0040 A370) 0008 1110 Referenced Study Sequence\n";
#  $x = mesa::compareSequenceAttributeLevel2(
#	$logLevel,
#	"0040 A370", "0008 1110", "0008 1155",	# Referenced SOP Instance UID
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0008 0050",		# Accession Number
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring (0040 A370) 0032 1064 Requested Procedure Code Sequence\n";
  print main::LOG "CTX: Ignoring (0040 A370) 0040 2016 Placer Order Number/Imaging Service Request\n";
  print main::LOG "CTX: Ignoring (0040 A370) 0040 2017 Filler Order Number/Imaging Service Request\n";

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 A370", "0040 1001",		# Requested Procedure ID
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring (0040 A370) 0032 1060 Requested Procedure Description\n";

  print main::LOG "CTX: 0040 4016 Referenced GP SPS Sequence should not be included\n";
  ($x, $refSOPClassUID) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0008 1150", "0040 4016");
  if ($refSOPClassUID eq "") {
    print main::LOG "CTX: Good, it appears GP-PPS message does not have this sequence\n";
  } else {
    print main::LOG "ERR: GP-PPS contains (0040 4016) 0008 1150.\n" .
		    "ERR: This Performed Work status is for an unscheduled step \n" .
		    "ERR: and should not include this sequence (0040 4016)\n";
    $rtnValue = 1;
  }

  @topLevelTags = (
	"0010 0010",		# Patient Name
	"0010 0020",		# Patient ID
	"0010 0030",		# Patient DOB
	"0010 0040",		# Patient Sex
  );
  foreach $tag(@topLevelTags) {
    $x = mesa::compareAttribute(
	$logLevel,
	$tag,
	"$gpppsFileMESA",
	"$gpppsFileTest");
    $rtnValue = 1 if ($x != 0);
  }

  # General Purpose Performed Procedure Step Information
  print main::LOG "CTX: General Purpose PPS Information\n";
  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0100",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0102",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttributeLevel2(
	$logLevel,
	"0040 4035", "0040 4009", "0008 0104",	# Actual Human Performers Sequence
						# -> Human Performer Code Sequence
						#  -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring (0040 4035) 0040 4037 Human Performer's Name\n" if ($logLevel >= 3);
  print main::LOG "CTX: Ignoring (0040 4035) 0040 4036 Human Performer's Organization\n" if ($logLevel >= 3);

  ($x, $ppsID) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0253");
  if ($x == 1 || $ppsID eq "") {
    print main::LOG "ERR: Unable to get PPS ID (0040 0253) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: (0040 0253) PPS ID <$ppsID>\n";
  }

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0100", # Performed Station Name Code Sequence
				  # -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0102", # Performed Station Name Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4028", "0008 0104", # Performed Station Name Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring 0040 4029 Performed Station Class Code Sequence\n";
  print main::LOG "CTX: Ignoring 0040 4030 Performed Station Geographic Location Code Sequence\n";
  print main::LOG "CTX: Ignoring 0040 4007 Performed Processing Applications Code Sequence\n";
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0100", # Performed Processing Applications Code Sequence
#				  # -> Code Value
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0102", # Performed Processing Applications Code Sequence
#				  # -> Coding Scheme Designator
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);
#
#  $x = mesa::compareSequenceAttribute(
#	$logLevel,
#	"0040 4007", "0008 0104", # Performed Processing Applications Code Sequence
#				  # -> Code Meaning
#	"$gpppsFileMESA",
#	"$gpppsFileTest");
#  $rtnValue = 1 if ($x != 0);

  ($x, $ppsStartDate) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0244");
  if ($x == 1 || $ppsStartDate eq "") {
    print main::LOG "ERR: Unable to get PPS Start Date (0040 0244) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0244 PPS Start Date <$ppsStartDate>\n";
  }

  ($x, $ppsStartTime) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0245");
  if ($x == 1 || $ppsStartTime eq "") {
    print main::LOG "ERR: Unable to get PPS Start Time (0040 0245) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0245 PPS Start Time <$ppsStartTime>\n";
  }

  $x = mesa::compareAttribute(
	$logLevel,
	"0040 4002",		# GP-PPS Status
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  print main::LOG "CTX: Ignoring 0040 0254 Performed Procedure Step Description\n" if ($logLevel >= 3);
  print main::LOG "CTX: Ignoring 0040 0280 Comments on the Performed Procedure Step\n" if ($logLevel >= 3);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0100", # Performed Workitem Code Sequence
				  # -> Code Value
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0102", # Performed Workitem Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4019", "0008 0104", # Performed Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  ($x, $ppsEndDate) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0250");
  if ($x == 1 || $ppsEndDate eq "") {
    print main::LOG "ERR: Unable to get PPS End Date (0040 0244) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0250 PPS End Date <$ppsEndDate>\n";
  }

  ($x, $ppsEndTime) = mesa::getDICOMAttribute($logLevel, $gpppsFileTest, "0040 0251");
  if ($x == 1 || $ppsEndTime eq "") {
    print main::LOG "ERR: Unable to get PPS End Time (0040 0251) from $gpppsFileTest\n";
    $rtnValue = 1;
  } else {
    print main::LOG "CTX: 0040 0251 PPS End Time <$ppsEndTime>\n";
  }

  # General Purpose Results
  print main::LOG "CTX: General Purpose Results\n";
  print main::LOG "CTX: Ignoring 0040 4033 Output Information Sequence\n";

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0100", # Requested Subsequence Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0102", # Requested Subsequence Workitem Code Sequence
				  # -> Coding Scheme Designator
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  $x = mesa::compareSequenceAttribute(
	$logLevel,
	"0040 4031", "0008 0104", # Requested Subsequence Workitem Code Sequence
				  # -> Code Meaning
	"$gpppsFileMESA",
	"$gpppsFileTest");
  $rtnValue = 1 if ($x != 0);

  return $rtnValue;
}

# usage: evaluate_mpps_vs_template($mppsFilename, $templateFilename)
# returns the number of errors encountered (0 for no errors).  May die in 
# case of serious error.
sub evaluate_mpps_vs_template {
    my $mpps = shift or die "MPPS filename not passed";
    my $template = shift or die "template filename not passed";
# Algorithm: Read through every line of the template file, discarding comments.
# See if the element in the line exists in the mpps file and get its value.
# Evaluate according to template code:
# <T1> -- element must exist and must not be empty in mpps
# <T2> -- element must exist in mpps, but it may be empty
# <T3> -- no error.
# <CS1> -- If sequence does not exist or exists but is empty, no error.  
#          Otherwise, error if element does not exist or has no value.
# Otherwise (verbatim case) -- value of mpps must match value in template.
# Example of a template line:
#
# 0040.0270,0040.1001 <T2>                // Requested Procedure ID 

# an aside: this is a different flavor of evaluation function which reads from
# a generic text (template) file, and checks merely for the existence or absence
# of elements, as defined by their type.  It is implemented in the 1701 evaluation 
# script for the evidence creator actor.

    my $errorCount = 0;
    open TEMPLATE, $template or die $!;
    while (my $line = <TEMPLATE>) {
        my $origLine = $line;
        $line =~ s(\/\/.*$)(); # take off comments
        $line =~ s/\s+$//; # take off trailing whitespace    
        $line =~ s/^\s+//; # take off leading whitespace
        next if $line eq "";

# $tag is the tag name, $value is its value from the template
        my ($tag, $value) = split /\s/, $line, 2;

        my ($errorCode, $MPPSvalue) = mesa::getDICOMElements($tag, $mpps, 1);
        if ($errorCode > 1) {   # other error reading value, see source of above call
            die "Error ($errorCode) in mesa::getDICOMElements parsing line\n $origLine " . 
                "in $template\n" if $errorCode;
        }

        $MPPSvalue =~ s/^\s*[0-9a-f]{4} [0-9a-f]{4}//i; #strip off the leading tag
        $MPPSvalue =~ s/\/\/.+$//; # take off comments
# take off leading and trailing whitespaces from MPPSvalue
        $MPPSvalue =~ s/^\s+//;
        $MPPSvalue =~ s/\s+$//;

        if ($value =~ /<T1>/) {
            if ($errorCode != 0) {
                print main::LOG "Type 1 element not present in $mpps as required by, \n" .
                    "\t$origLine\n";
                $errorCount++;
            } elsif (mesa::elementIsEmpty($tag, $mpps)) {
                print main::LOG "Type 1 element has empty value in $mpps as required by, \n" .
                    "\t$origLine\n";
                $errorCount++;
            }
        } elsif ($value =~ /<T2>/) {
            if ($errorCode != 0) {
                print main::LOG "Type 2 element not found in $mpps as required by, \n" . 
                    "\t$origLine\n";
                $errorCount++;
            }
        } elsif ($value =~ /<T3>/) {
            # all good if we get here...
        } elsif ($value =~ /<CS1>/) {
            # if parent element doesn't exist, we're OK.  If it does, we need a value.
            my @elements = split /,/, $tag;
            die "<CS1> on a tag not in a sequence: \n\t$line\n" if (scalar(@elements) < 2);
            # Create tag which excludes the topmost element
            pop @elements;
            my $seqTag = join ',', @elements;
            if (mesa::elementExists($seqTag, $mpps) and 
                    (mesa::elementIsEmpty($seqTag, $mpps) == 0)) {
                # parent does exist and is not empty
                my $emptiness = mesa::elementIsEmpty($tag, $mpps);
                if ($emptiness == -1) { # this element is not found in the mpps file
                    print main::LOG "Type 1C element not present in $mpps but " . 
                        "sequence $seqTag is present.  Violates:\n\t$origLine\n";
                    $errorCount++;
                } elsif ($emptiness == 1) { #element is found, but empty
                    print main::LOG "Type 1C element is empty in $mpps and sequence " .
                        "$seqTag is present.  Violates:\n\t$origLine\n";
                    $errorCount++;
                }
            }
        } else {    # this is a value we need to match verbatim
            if (not $MPPSvalue eq $value) {
                print main::LOG "Element value in $mpps ($MPPSvalue) does not match $value, " .
                    "as required by, \n\t$origLine\n";
                $errorCount++;
            }
        }
    }
    return $errorCount;
}

sub evaluate_APPOINT {
  my ($logLevel, $mesaAPPOINT, $testAPPOINT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_APPOINT $mesaAPPOINT $testAPPOINT\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"SCH",  2,  75, "Filler Appointment ID",
	"SCH", 27,  22, "Filler Order Number",
	"RGS",  1,   4, "SetID - RGS",
	"AIS",  1,   4, "SetID - AIS",
	"AIS",  3, 250, "Universal Service ID",
	"AIS",  4,  26, "Start Date/Time"
  );

  my $idx = 0;
  print main::LOG "CTX: Look for non-zero fields and date/time formats\n" if ($logLevel >= 3);
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];

    my ($status, $v) = mesa::getHL7Field($logLevel, $testAPPOINT, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testAPPOINT\n";
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

    ## Validate Date/Time if any
    if ($fieldName =~ m/Date\/Time/ig) {
      my $date = Date::Manip::ParseDate($v);
      if (!$date) {
        print main::LOG "ERR: Bad Date/Time: $v\n";
      } else {
        print main::LOG "CTX: $segment $field $fieldName: <$v> Format looks good\n" if ($logLevel >= 3);
      }
    }
    $idx += 4;
  }

  @equivalentFields = (
	"SCH",  6, 250, 0, "Event Reason",
	"SCH", 11, 200, 0, "Appointment Timing Quantity",
	"SCH", 16, 250, 0, "Filler Contact Person",
#	SCH 20 is optional, do not test
#	"SCH", 20, 250, 0, "Entered by Person",
	"SCH", 26,  22, 0, "Placer Order Number",
	"AIS",  2,   3, 0, "Segment Action Code",
	"AIS",  3, 250, -1, "Universal Service ID",
	"AIS",  3, 250, 1, "Universal Service ID: Code",
	"AIS",  3, 250, 2, "Universal Service ID: Meaning",
	"AIS",  3, 250, 3, "Universal Service ID: Coding Scheme",
	"AIS",  3, 250, 5, "Universal Service ID: Alternate Text"
  );

  $idx = 0;
  print main::LOG "\nCTX: Look for equivalent fields\n" if ($logLevel >= 3);
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $maxLen    = $equivalentFields[$idx+2];
    my $component = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];

    if ($component < 0) {
      ($status, $vTest) = mesa::getHL7Field($logLevel, $testAPPOINT, $segment, $field, 0, $fieldName);
      if ($status != 0) {
        print main::LOG "Could not get HL7 Field for $segment, $field:$component, $fieldName\n";
        print main::LOG "File name is $testAPPOINT\n";
        return 1;		# Non-zero error count
      }
      ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaAPPOINT, $segment, $field, 0, $component, $fieldName);
      if ($status != 0) {
        print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
        print main::LOG "File name is $mesaAPPOINT\n";
        return 1;		# Non-zero error count
      }
      print main::LOG "CTX: $segment $field $fieldName: <T:$vTest> <M:$vMESA>\n" if ($logLevel >= 3);
    } else {
      ($status, $vTest) = mesa::getHL7Field($logLevel, $testAPPOINT, $segment, $field, $component, $fieldName);
      if ($status != 0) {
        print main::LOG "Could not get HL7 Field for $segment, $field:$component, $fieldName\n";
        print main::LOG "File name is $testAPPOINT\n";
        return 1;		# Non-zero error count
      }
      ($status, $vMESA) = mesa::getHL7Field($logLevel, $mesaAPPOINT, $segment, $field, $component, $component, $fieldName);
      if ($status != 0) {
        print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
        print main::LOG "File name is $mesaAPPOINT\n";
        return 1;		# Non-zero error count
      }
      my $len = length ($vTest);
      print main::LOG "CTX: $segment $field $fieldName: <T:$vTest> <M:$vMESA> length: $len\n" if ($logLevel >= 3);

      if ($len == 0) {
        print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
        #print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
        $errorCount++;
      } elsif ($len > $maxLen) {
        print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
        print main::LOG "ERR: $segment $field: Your length is $len\n";
        print main::LOG "ERR: Test value: $vTest\n";
        #print main::LOG "REF: $reference\n" if ($logLevel >= 4);
        $errorCount++;
      } elsif ($vTest ne $vMESA) {
        print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
        print main::LOG "ERR: Test value: $vTest\n";
        print main::LOG "ERR: MESA value: $vMESA\n";
        $errorCount++;
      }
    }
    $idx += 5;
  }

  return $errorCount
}

sub evaluate_KON_TFCTE_Attributes {
  my ($logLevel, $path, @attributes) = @_;
  my $mesaCodeValue = $attributes[0];
  my $mesaDesignator = $attributes[1];
  my $mesaCodeMeaning = $attributes[2];
  my $errorCount = 0;

  my ($s1,$codeValue)=mesa::getDICOMAttribute($logLevel, $path, "0008 0100", "0040 a043");
  if($codeValue ne $mesaCodeValue){
    print main::LOG "ERR: Code Value under test does not equal MESA value \n";
    print main::LOG "ERR: Test value: $codeValue\n";
    print main::LOG "ERR: MESA value: $mesaCodeValue\n";
    $errorCount++ if($errorCount == 0);
  }else{
    print main::LOG "INFO: Code Value under test equals MESA value: $mesaCodeValue \n" if($logLevel >=3);
  }
    
  my($s2, $designator)=mesa::getDICOMAttribute($logLevel, $path, "0008 0102", "0040 a043");
  if($designator ne $mesaDesignator){
    print main::LOG "ERR: Coding Schema Designator under test does not equal MESA value \n";
    print main::LOG "ERR: Test value: $designator\n";
    print main::LOG "ERR: MESA value: $mesaDesignator\n";
    $errorCount++ if($errorCount == 0);
  }else{
    print main::LOG "INFO: Coding Schema Designator under test equals MESA value: $mesaDesignator \n" if($logLevel >=3);
  }

  my($s3,$meaning)=mesa::getDICOMAttribute($logLevel, $path, "0008 0104", "0040 a043");
  if($meaning ne $mesaCodeMeaning){
    print main::LOG "ERR: Code Meaning under test does not equal MESA value \n";
    print main::LOG "ERR: Test value: $meaning\n";
    print main::LOG "ERR: MESA value: $mesaCodeMeaning\n";
    $errorCount++ if($errorCount == 0);
  }else{
    print main::LOG "INFO: Code Meaning under test equals MESA value: $mesaCodeMeaning \n" if($logLevel >=3);
  }
  
  return $errorCount;
}

sub evaluate_Image_References{
  my($logLevel, $path, @images) = @_;
  
  #$path="/opt/mesa/storage/modality/T3000TEMP/sr_511_ct.dcm";
  my($status,%hash)=mesa::getKONInstanceManifest($logLevel,$path);
  return 1 if($status != 0);
  
  my $c1 = keys( %hash );
  my $c2 = @images;
  if($c1!=$c2){
  #if(keys(%hash) != scalar(@imges)){
    print main::LOG "ERR: There are ".keys(%hash)." image(s) referenced in KON, but there are ".@images." actual image(s).\n";
    return 1;
  }elsif($logLevel >= 3){
    while(($key, $value) = each(%hash) ) {
      print main::LOG "$key => $value\n";
    }
  }

  foreach (@images){
    my($s1,$instanceUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0018");
    my($s2,$classUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0016");
    if($hash{$instanceUID} eq $classUID){
      delete $hash{$instanceUID};
      print main::LOG "InstanceUID $instanceUID with ClassUID $classUID referenced in KON has been found.\n" if($logLevel >=3);
    } 
  }

  if(keys(%hash) > 0){
    print main::LOG "ERR: There are still ".keys(%hash)." image(s) referenced in KON, but not found.\n";
    return 1;
  }else{
    return 0;
  }  
}

sub evaluate_deidentification{
  my($logLevel, $deltaDir, $deltaFile, @images) = @_;
  $openDelta = "../common/$deltaDir/$deltaFile";
  my %delta;
  my $error = 0;
  
  open(DELTA, $openDelta) || die "Could not open file $openDelta: $!\n";
  foreach(<DELTA>){
    my @tags = split /\s+/,$_;
    $delta{$tags[0]." ".$tags[1]} = $tags[2];
  }
  close(DELTA);
     
  my @keys = keys(%delta);
  #foreach(@keys){
  #  print "$_ => $delta{$_}\n";
  #}
  
  foreach $dcm (@images){
    print main::LOG "CTX: Deidentification Evaluation of $dcm\n" if($logLevel >= 3);
    foreach $key (@keys){
      my($s,$value)=mesa::getDICOMAttribute($logLevel, $dcm, $key);
      if (($value eq "") && ($delta{$key} eq "#")){
        print main::LOG "INFO: $key is deidentified to 0 length value \n" if($logLevel >= 3);
      }elsif(($value eq $delta{$key}) && ($delta{$key} ne "#")){
        print main::LOG "INFO: $key is deidentified to $value \n" if($logLevel >= 3);
      }else{
        print main::LOG "ERR: In $dcm, $key is not deidentified to $delta{$key}, the tag value is still $value \n";
	$error = 1;
      }	 
    }
  }
  return $error;
}

#Use Clunie tool to check if KON conforms Dicom standard.
sub  evaluate_KON_TFCTE {
  # Comment this out for now. It does not work very well with windows environments
  return 0;
  my ($logLevel, $path, $testcase, $testnum, $session) = @_;
  #my $errorCount = 0;
  my $osName = $main::MESA_OS;
  my $evalString = "";
  
  if ($osName eq "WINDOWS_NT") {
    $evalString = "dvtcmd -m $testcase/$session $path";
  } else {
    $evalString = "$main::MESA_TARGET/bin/dciodvfy $path 1>".$testcase."/dciodvfy_$testnum.out 2>&1";
  }
  
  print main::LOG "CTX: $evalString \n" if ($logLevel >=3);
  `$evalString`;
  
  if ($osName eq "WINDOWS_NT") {
    print main::LOG "CTX: Please submit the xml files under $testcase to test manager for evaluation.\n";
  } else{    
    print main::LOG "CTX: Please submit ".$testcase."/dciodvfy_$testnum.out to test manager for evaluation.\n";
  }
  
  return 0;
  
#  the following code are commented out due to we are not counting how many errors. Instead will ask tester to send result to manager for evaluation.
#  open(TEMP,"dciodvfy.out")|| die "Error opening dciodvfy.out: $!\n";
#  while(<TEMP>){
#    chomp;
#    print main::LOG "DCIODVFY: $_\n";
#    print $_."\n";
#    $errorCount++ if(/^Error/); 
#  }
#  close TEMP;
  
#  if($errorCount > 0){
#    return 1;
#  }else{
#    return 0;
#  }
}

sub eval_mpps_scheduled
{
  my ($level, $protocolCodeFlag, $aet, $masterFile,$testFile) = @_;

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

  $x = "$main::MESA_TARGET/bin/mpps_evaluate -l $level -P $protocolCodeFlag ";
  $x .= " mod 1 $testFile $masterFile ";

  print main::LOG "$x\n" if ($level >= 3);
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "MPPS comparison failed for scheduled case \n";
    print main::LOG " File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub eval_dicom_image_extended
{
  my ($level, $masterFile,$testFile) = @_;

  my @attributes = (
        "0008 0005", "Specific Character Set",
  );
  $idx = 0;
  my $rtnValue = 0;
  while ($idx < scalar(@attributes)) {
    my ($x, $vMaster) = mesa::getDICOMAttribute($level, $masterFile, $attributes[$idx]);
    print main::LOG "CTX: Master: $attributes[$idx] $attributes[$idx+1] $vMaster\n";
    if ($vMaster ne "") {

      my ($xy, $vTest) = mesa::getDICOMAttribute($level, $testFile, $attributes[$idx]);
      print main::LOG "CTX: Test:   $attributes[$idx] $attributes[$idx+1] $vTest\n";
      if ($vTest ne $vMaster) {
	print main::LOG "ERR: Value in test image ($vTest) differs from expected ($vMaster)\n";
	print main::LOG "ERR: Test:   $attributes[$idx] $attributes[$idx+1] $vTest\n";
	$rtnValue = 1;
      }
    }
    $idx += 2;
  }

  return $rtnValue;
}

sub eval_mpps_extended {
  my ($level, $protocolCodeFlag, $aet, $masterFile,$testFile) = @_;
  print main::LOG "CTX: mesa::eval_mpps_extended $level, $protocolCodeFlag, $aet $masterFile $testFile\n" if ($level >= 3);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR: In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG "ERR:  This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "ERR: In comparing MPPS, we are missing the MPPS status:\n" .
        "  $testFile\n";
    print main::LOG "ERR:  You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  my @attributes = (
        "0008 0005", "Specific Character Set",
  );
  $idx = 0;
  my $rtnValue = 0;
  while ($idx < scalar(@attributes)) {
    my ($x, $vMaster) = mesa::getDICOMAttribute($level, $masterFile, $attributes[$idx]);
    print main::LOG "CTX: Master: $attributes[$idx] $attributes[$idx+1] $vMaster\n";
    if ($vMaster ne "") {

      my ($xy, $vTest) = mesa::getDICOMAttribute($level, $testFile, $attributes[$idx]);
      print main::LOG "CTX: Test:   $attributes[$idx] $attributes[$idx+1] $vTest\n";
      if ($vTest ne $vMaster) {
	print main::LOG "ERR: Value in test image ($vTest) differs from expected ($vMaster)\n";
	print main::LOG "ERR: Test:   $attributes[$idx] $attributes[$idx+1] $vTest\n";
	$rtnValue = 1;
      }
    }
    $idx += 2;
  }

  return $rtnValue;
}

sub evaluate_ian_img_mgr {
  my ($logLevel, $stdDir, $storageDir, $testAETitle) = @_;
  my $error = 0;
  
  if (! -e($storageDir)) {
    print main::LOG "ERR: MESA storage directory does not exist \n";
    print main::LOG "ERR: Directory is expected to be: $storageDir \n";
    print main::LOG "ERR: Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  #In generating and sending IAN, we make use of MPPS UID. so here we need it again.
  if (! open(MPPS_HANDLE, "< $stdDir/mpps_uid.txt")) {
    print main::LOG "ERR: Could not open MPPS UID File: $stdDir/mpps_uid.txt\n";
    return 1;
  }

  $mpps_UID = <MPPS_HANDLE>;
  chomp $mpps_UID;
  print main::LOG "CTX: MPPS UID = $mpps_UID \n" if ($logLevel >= 3);

  if (! -e("$storageDir/$mpps_UID")) {
    print main::LOG "ERR: MESA IAN directory does not exist \n";
    print main::LOG "ERR: Directory is expected to be: $storageDir/$mpps_UID \n";
    print main::LOG "ERR: This implies you did not forward IAN message for Image Available Notice event.\n";
    return 1;
  }

  if (! -e("$storageDir/$mpps_UID/ian.dcm")) {
    print main::LOG "ERR: IAN file does not exist \n";
    print main::LOG "ERR: File is expected to be: $storageDir/$mpps_UID/ian.dcm \n";
    print main::LOG "ERR: This implies a problem in the MESA software because the directory exists but the file is missing.\n";
    return 1;
  }else{
    print main::LOG "LOG: Find IAN file $storageDir/$mpps_UID/ian.dcm\n";
  }

  my($s1,$mppsClassUID)=mesa::getDICOMAttribute($logLevel, "$storageDir/$mpps_UID/ian.dcm", "0008 1150", "0008 1111");
  my($s7,$mppsInstUID)=mesa::getDICOMAttribute($logLevel, "$storageDir/$mpps_UID/ian.dcm", "0008 1155", "0008 1111");
  if($mppsClassUID ne "1.2.840.10008.3.1.2.3.3"){
    print main::LOG "ERR: Referenced Performed Procedure Step SOP Class UID should be 1.2.840.10008.3.1.2.3.3, but your value is $mppsClassUID\n" if ($logLevel >= 3);
    $error++;
  }
  if($mppsInstUID ne $mpps_UID){
    print main::LOG "ERR: Referenced Performed Procedure Step instance UID should be $mpps_UID, but your value is $mppsInstUID\n" if ($logLevel >= 3);
    $error++;
  }
  
  my %hash;
  my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i 1 0008 1115 $storageDir/$mpps_UID/ian.dcm $main::MESA_STORAGE/tmp/refencedSOPseq.dcm";
  print main::LOG "CTX: $x\n" if ($logLevel >= 3);
  `$x`;
  if ($?){
    print main::LOG "ERR: $?\n"; 
    $error++;
  } 
  
  #Processing IAN:
  if(!$error){
    my $idx = 1;
    my $done = 0;
    my $seriesPath = "$main::MESA_STORAGE/tmp/refencedSOPseq.dcm";
    while (! $done) {
      my ($s1, $instanceUID) = mesa::getDICOMAttribute($logLevel, $seriesPath, "0008 1155", "0008 1199", $idx);
      my ($s2, $classUID) = mesa::getDICOMAttribute($logLevel, $seriesPath, "0008 1150", "0008 1199", $idx);
      #print "$idx $s1 $s2 <$classUID> $instanceUID\n";
      if ($s1 != 0) {
        print main::LOG "ERR: In $i item of referenced SOP sequence, could not get instance UID value for index $idx\n";
        #return (1, %hash);
      }
      if ($instanceUID eq "") {
          $done = 1;
      } else {
        #print "<$classUID> $instanceUID\n";
        # Add instance UID and class UID to a hash
	my($s3,$avail) = mesa::getDICOMAttribute($logLevel, $seriesPath,"0008 0056", "0008 1199", $idx);
        my($s4,$retrieveAETitle) = mesa::getDICOMAttribute($logLevel, $seriesPath,"0008 0054", "0008 1199", $idx);
	if($avail ne "ONLINE" && $avail ne "NEARLINE" && $avail ne "OFFLINE" && $avail ne "UNAVAILABLE"){
          print main::LOG "ERR: Instance Availability should be one of the following values: ONLINE/NEARLINE/OFFLINE/UNAVAILABLE.But your value is $avail\n";
          $error++;
        }
    
        if($retrieveAETitle ne $testAETitle){
           print main::LOG "ERR: Retrieve AE Title is incorrect. Your value is $retrieveAETitle, but it should be $testAETitle\n";
           $error++;
        }
	
        $hash{$instanceUID} = $classUID;
        $idx++;
      }
    }
  }  
  
  my $noMissing = 0;
  find(\&edits, $stdDir);
  
  # We just work on one study one series.
  my($s2,$studyUID)=mesa::getDICOMAttribute($logLevel, "$storageDir/$mpps_UID/ian.dcm", "0020 000D");
  my($s3,$seriesUID)=mesa::getDICOMAttribute($logLevel, "$storageDir/$mpps_UID/ian.dcm", "0020 000E", "0008 1115");
  
  #processing each referenced dicom object.
  foreach (@files){
    my($s1,$instanceUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0018");
    my($s2,$classUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0016");
    my($s3,$testStudyUID) = mesa::getDICOMAttribute($logLevel, $_,"0020 000D");
    my($s4,$testSeriesUID) = mesa::getDICOMAttribute($logLevel, $_,"0020 000E");
    
    if ($testStudyUID ne $studyUID){
      print main::LOG "ERR: The Study UID is not match. Referenced iamges study UID is $testStudyUID, but it is $studyUID in IAN\n";
      $error++;
    }
  
    if ($testSeriesUID ne $seriesUID){
      print main::LOG "ERR: The Series UID is not match. Referenced iamges study UID is $testSeriesUID, but it is $seriesUID in IAN\n";
      $error++;
    }
    
    if($hash{$instanceUID} eq $classUID){
      delete $hash{$instanceUID};
      print main::LOG "CTX: InstanceUID $instanceUID with ClassUID $classUID referenced in IAN has been found.\n" if($logLevel >=3);
    } else {
      print main::LOG "ERR: InstanceUID $instanceUID with ClassUID $classUID is not referenced in IAN.\n";
      $noMissing++;
    }
  }
  
  if ($noMissing > 0){
    print main::LOG "ERR: There are $noMissing image(s) not referenced in the IAN.\n";
    $error++;
  }else{
    if(keys(%hash) > 0){
      print main::LOG "ERR: There are still ".keys(%hash)." image(s) referenced in IAN, but not found in image list as follow:\n";
      evaluate_tfcte::displayMap("",%hash);;
      $error++;
    }else{
      print main::LOG "CTX: Referenced SOP Sequence has equal number of image references and each refers to the correct image.\n";
    }
  }
  
  return $error;
}

1;
