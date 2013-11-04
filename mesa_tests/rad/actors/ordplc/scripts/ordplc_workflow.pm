#!/usr/local/bin/perl -w

# Runs the Order Placer scripts interactively

use Env;
package ordplc;
require Exporter;
@ISA = qw(Exporter);

my %testCase = ( 
		151 => "true",
		152 => "true",
	       );

sub print_config_params {
  foreach $varname (keys %varnames) {
    print "Variable $varname = $varnames{$varname} \n";
  }
}

sub processTransaction1 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst eq "OF") {	# Send the ADT to the MESA Order Filler
    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    print "IHE Transaction 1: $pid $patientName \n";
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";
    $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, "localhost",
	$main::mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
    return 0;
  }

  if ($dst ne "OP") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for Order Placer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";
  print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip ADT to MESA OP \n";
  } else {
    $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, "localhost",
	$main::mesaOrderPlacerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Placer ($main::opHostHL7 $main::opPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $main::opHostHL7, $main::opPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction1Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OP") {
    print "IHE Transaction 1 from ($src) to ($dst) is not required for Order Placer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 1: $pid $patientName \n";
  print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip ADT to MESA OP \n";
  } else {
    $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Placer ($main::opHostHL7 $main::opPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_secure(
	"../../msgs", $msg, $main::opHostHL7, $main::opPortHL7,
	"randoms.dat",
	"mesa_1.key.pem",
	"mesa_1.cert.pem",
	"test_sys_1.cert.pem",
	"NULL-SHA");
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction2 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  print "IHE Transaction 2: $pid $patientName $procedureCode \n";

  if ($dst eq "OF") {
    print "\nYou are expected to place an order to the MESA Order Filler\n";
    print "Name: $patientName, PID: $pid, Universal Service ID: $procedureCode\n";
    print "All parameters can be found in file $hl7Msg\n";

    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);

    if ($selfTest == 1) {
      print "Looks like this is run directly for MESA testing; send ORM to MESA OF \n";
      $x = mesa::send_hl7_log(
	$logLevel, "../../msgs", $msg, "localhost",
	$main::mesaOrderFillerPortHL7);
      mesa::xmit_error($msg) if ($x != 0);
    } else {
    }
  } else {
# We are going to send them an order.
    die "We need to implement sending an Order from OF to OP";
  }
  return 0;
}

sub processTransaction2Secure {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  print "IHE Transaction 2: $pid $patientName $procedureCode \n";

  if ($dst eq "OF") {
    print "\nYou are expected to place an order to the MESA Order Filler\n";
    print "Name: $patientName, PID: $pid, Universal Service ID: $procedureCode\n";
    print "All parameters can be found in file $hl7Msg\n";

    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);

    if ($selfTest == 1) {
      print "Looks like this is run directly for MESA testing; send ORM to MESA OF \n";
      $x = mesa::send_hl7_secure(
	"../../msgs", $msg, "localhost", $main::mesaOrderFillerPortHL7,
	"randoms.dat",
	"test_sys_1.key.pem",
	"test_sys_1.cert.pem",
	"mesa_1.cert.pem",
	"NULL-SHA");
      mesa::xmit_error($msg) if ($x != 0);
    } else {
    }
  } else {
# We are going to send them an order.
    die "We need to implement sending an Order from OF to OP";
  }
  return 0;
}

sub processTransaction3 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");
  print "IHE Transaction 3: $pid $patientName $procedureCode \n";

  if ($dst eq "OF") {
    my $fillerOrderNumber = mesa::getField($hl7Msg, "OBR", "3", "0", "Filler Order Number");
    print "\nIn this part of Transaction 3, the Order Filler has sent an ORM\n";
    print " to your Order Placer. We expect your system to respond with an ORR.\n";
    
    print "Name: $patientName, PID: $pid, Universal Service ID: $procedureCode\n";
    print "Filler Order Number: $fillerOrderNumber\n";
    print "All parameters can be found in file $hl7Msg\n";

    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);

    if ($selfTest == 1) {
      print "Looks like this is run directly for MESA testing; send ORM to MESA OF \n";
      $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
      mesa::xmit_error($msg) if ($x != 0);
    } else {
    }
  } else {
# We are going to send them an order.
    print "\nIn this part of Transaction 3, the Order Filler initiates the order\n";
    print "MESA will now send ORM message ($msg) to your Order Placer ($opHostHL7 $opPortHL7) \n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $opHostHL7, $opPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }
  return 0;
}

sub processTransaction4a {
  print "Transaction 4a not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction4b {
  print "Transaction 4b not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction4 {
  print "Transaction 4 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction5 {
  print "Transaction 5 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction6 {
  print "Transaction 6 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction7 {
  print "Transaction 7 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction8 {
  print "Transaction 7 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction10 {
  print "Transaction 10 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction12 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  if ($dst ne "OP") {
    print "IHE Transaction 12 from ($src) to ($dst) is not required for Order Placer test\n";
    return 0;
  }

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid =         mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

  print "IHE Transaction 12: $pid $patientName \n";
  print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; skip ADT to MESA OP \n";
  } else {
    $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, "localhost", $mesaOrderFillerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  }

  print "\nMESA will now send ADT message ($msg) to your Order Placer ($opHostHL7 $opPortHL7) \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  $x = mesa::send_hl7_log($logLevel, "../../msgs", $msg, $opHostHL7, $opPortHL7);
  mesa::xmit_error($msg) if ($x != 0);
  return 0;
}

sub processTransaction13 {
  print "Transaction 13 not necessary to test the Order Placer \n";
  return 0;
}

sub processTransaction14 {
  print "Transaction 14 not needed for OP tests\n";
  return 0;
}

sub processTransaction48 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg) = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $fillerAppID = mesa::getField($hl7Msg, "SCH", "2", "0", "Filler Appointment ID");
  my $eventReason = mesa::getField($hl7Msg, "SCH", "6", "0", "Event Reason");
  my $fillerContactPerson = mesa::getField($hl7Msg, "SCH", "16", "0", "Filler Contact Person");
  my $placerOrderNumber = mesa::getField($hl7Msg, "SCH", "26", "0", "Placer Order Number");
  my $fillerOrderNumber = mesa::getField($hl7Msg, "SCH", "27", "0", "Filler Order Number");

  my $appointmentType = "";
  if ($msg =~ m/s12/g) {
     $appointmentType = "NEW";
  } elsif ($msg =~ m/s13/g) {
     $appointmentType = "UPDATE";
  } else {
     $appointmentType = "CANCEL";
  }

  print "\nIHE Transaction 48: $fillerAppID $placerOrderNumber $fillerOrderNumber\n";
  print "\nMESA Order Filler will now send HL7 appointment notification ($msg) message to your Order Placer ($main::mesaOrderPlacerPortHL7)\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  if ($selfTest == 1) {
    print "Looks like this is run directly for MESA testing; send appointment message to Order Placer \n";
    print "MESA will send $appointmentType APPOINT message ($hl7Msg) to $dst\n";
    $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaOrderPlacerPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
  } else {
  }
  return 0;

}

sub processTransaction {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;

  if ($trans eq "1") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction1($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "2") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction2($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "3") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction3($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "4a") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4a(@tokens);
  } elsif ($trans eq "4b") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4b(@tokens);
  } elsif ($trans eq "4") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction4(@tokens);
  } elsif ($trans eq "5") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction5(@tokens);
  } elsif ($trans eq "6") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction6(@tokens);
  } elsif ($trans eq "7") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction7(@tokens);
  } elsif ($trans eq "8") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction8(@tokens);
  } elsif ($trans eq "10") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction10(@tokens);
  } elsif ($trans eq "12") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction12($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "13") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction13(@tokens);
  } elsif ($trans eq "14") {
    shift (@tokens); shift (@tokens);
    $rtnValue = processTransaction14(@tokens);
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}

sub printText {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $txtFile = "../common/" . $tokens[1];
  open TXT, $txtFile or die "Could not open text file: $txtFile";
  while ($line = <TXT>) {
    print $line;
  }
  close TXT;
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
}

sub printPatient {
  my $cmd = shift(@_);
  my @tokens = split /\s+/, $cmd;

  my $hl7Msg = "../../msgs/" . $tokens[1];
  my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  print "Patient Name: $patientName \n";
  print "Patient ID:   $pid\n";
  print "\nHit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
}

sub localScheduling {
  print "LOCALSCHEDULING is not needed to test the Order Placer\n";
  return 0;
}

sub unscheduledImages {
  print "UNSCHEDULED-IMAGES is not needed to test the Order Placer\n";
  return 0;
}

sub processOneLine {
  my ($cmd, $logLevel, $selfTest, $testCase)  = @_;
  my $keyExist;
  if ($cmd eq "") {
    return 0;
  }
  my @verb = split /\s+/, $cmd;
  my $rtnValue = 0;
  
  # Check to see if $testCase exists in %testCase
  print "\n\n\n C A M E - H E R E \n\n\n";
  if (exists($testCase{$testCase})) {
    $keyExist = 1;
    print "\n\nYES - $keyExist\n";
  } else {
    $keyExist = 0;
    print "\n\nNO - $keyExist\n";
  }

  if ($verb[0] eq "TRANSACTION") {
    $rtnValue = processTransaction($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "TEXT") {
    printText($cmd) unless ($keyExist);
    #printText2($cmd) if ($keyExist);
  } elsif ($verb[0] eq "LOCALSCHEDULING") {
    localScheduling($cmd);
  } elsif ($verb[0] eq "UNSCHEDULED-IMAGES") {
    $rtnValue = unscheduledImages($cmd, $logLevel, $selfTest);
  } elsif ($verb[0] eq "PATIENT") {
    printPatient($cmd);
  } elsif (substr($verb[0], 0, 1) eq "#") {
    print "Comment: $cmd \n";
  } else {
    die "Did not recognize verb in command: $cmd \n";
  }
  return $rtnValue;
}

1;
