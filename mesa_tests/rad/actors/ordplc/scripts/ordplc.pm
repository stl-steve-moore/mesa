#!/usr/local/bin/perl -w

# Package for Order Placer scripts.

use Env;

use lib "../common/scripts";
require mesa;

package ordplc;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(
#);


# Send HL7 message to a server.  Arguments:
# 1 - Directory with messages
# 2 - Message to send
# 3 - Host name of target
# 4 - Port number of target

sub send_hl7 {
  my $hl7Dir = shift(@_);
  my $msg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 0 if $?;

  return 1;
}


sub read_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f) or die "Can't open $f.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }
  $ofPort = 2200;

  $opPort = $varnames{"TEST_HL7_PORT"};
  $opHost = $varnames{"TEST_HL7_HOST"};
#  $logLevel = $varnames{"LOGLEVEL"};

  return ($ofPort, $opHost, $opPort);
}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
        "MESA_ORD_PLC_PORT_HL7", "MESA_ORD_FIL_PORT_HL7",
        "TEST_HL7_HOST", "TEST_HL7_PORT"
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


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub evaluate_hl7 {
  my $verbose  = shift(@_);
  my $stdDir  = shift(@_);
  my $stdMsg  = shift(@_);
  my $testDir = shift(@_);
  my $testMsg = shift(@_);
  my $formatFile = shift(@_);
  my $iniFile = shift(@_);

  print main::LOG "$stdMsg $testMsg \n";

  my $pathStd = "$stdDir/$stdMsg";
  my $pathTest = "$testDir/$testMsg";

  my $evaluateCmd = "$main::MESA_TARGET/bin/hl7_evaluate ";
     $evaluateCmd .= " -v " if ($verbose);
     $evaluateCmd .= " -b $main::MESA_TARGET/runtime -m $formatFile $pathTest";

  print main::LOG "$evaluateCmd \n";
  print main::LOG `$evaluateCmd`;
  return 1 if ($?);

  my $compareCmd = "$main::MESA_TARGET/bin/compare_hl7 ";
     $compareCmd .= " -v " if ($verbose);
     $compareCmd .= " -b $main::MESA_TARGET/runtime -m $iniFile $pathStd $pathTest";

  print main::LOG "$compareCmd \n";
  print main::LOG `$compareCmd`;

  return 1 if ($?);

  return 0;
}

sub get_placer_number {
  my $msg = shift(@_);

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -f $msg ORC 2 0";
  my $placerOrderNumber = `$x`;

  return $placerOrderNumber;
}

sub announce_a01 {
  my $patName = shift(@_);
  my $opHost = shift(@_);
  my $opPort = shift(@_);

  print "\n" .
"The ADT system will send an A01 to register $patName as an inpatient.\n" .
" ADT message is going to your Order Placer at ($opHost:$opPort).\n\n" .
" Press <enter> when done or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a03 {
  my $patName = shift(@_);
  my $opHost = shift(@_);
  my $opPort = shift(@_);

  print "\n" .
"The ADT system will send an A03 to discharge $patName.\n" .
" ADT message is going to your Order Placer at ($opHost:$opPort).\n\n" .
" Press <enter> when done or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a04 {
  my $patName = shift(@_);
  my $opHost = shift(@_);
  my $opPort = shift(@_);

  print "\n" .
"The ADT system will send an A01 to register $patName as an outpatient.\n" .
" ADT message is going to your Order Placer at ($opHost:$opPort).\n\n" .
" Press <enter> when done or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a05 {
  my $patName = shift(@_);
  my $opHost = shift(@_);
  my $opPort = shift(@_);

  print "\n" .
"The ADT system will send an A05 to preregister $patName as an inpatient.\n" .
" ADT message is going to your Order Placer at ($opHost:$opPort).\n\n" .
" Press <enter> when done or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub request_procedure {
  my $pCode = shift(@_);
  my $patName = shift(@_);
  my $exampleORM = shift(@_);
  my $hostMESA = shift(@_);
  my $portMESA = shift(@_);

  print "\n" .
"In this step, we request that you order Procedure $pCode for $patName\n" .
" For an example, see message $exampleORM.\n" .
" Your ORM should go to the MESA Order filler at ($hostMESA:$portMESA).\n\n" .
" Press <enter> when done or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}


sub send_hl7_secure {
  my $hl7Dir = shift(@_);
  my $msg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7_secure -d ihe " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers ";

  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 0 if $?;

  return 1;
}
