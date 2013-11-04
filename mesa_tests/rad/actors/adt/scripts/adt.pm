#!/usr/local/bin/perl -w

use Env;

use lib "../common/scripts";
require mesa;

package adt;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(send_adt
#);

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
        "MESA_ORD_PLC_PORT_HL7", "MESA_ORD_FIL_PORT_HL7",
        "MESA_ORD_PLC_HOST", "MESA_ORD_FIL_HOST"
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

#sub read_config_params {
#  open (CONFIGFILE, "adt_test.cfg") or die "Can't open adt_test.cfg.\n";
#  while ($line = <CONFIGFILE>) {
#    chomp($line);
#    next if $line =~ /^#/;
#    next unless $line =~ /\S/;
#    ($varname, $varvalue) = split(" = ", $line);
#    $varnames{$varname} = $varvalue;
#  }
#  my $ofPort = $varnames{"MESA_ORD_FIL_PORT"};
#  my $ofHost = $varnames{"MESA_ORD_FIL_HOST"};
#
#  my $opPort = $varnames{"MESA_ORD_PLC_PORT"};
#  my $opHost = $varnames{"MESA_ORD_PLC_HOST"};
#
#  return ($ofPort, $ofHost, $opPort, $opHost);
#}

# Evaluate HL7 message against standard message
# Arguments:
#  1 - Directory with standard message
#  2 - Standard message
#  3 - Directory with message for evaluation
#  4 - Message to be evaluated
#  5 - File describes format of message for hl7_evaluate
#  6 - File describes fields to compare for compare_hl7

sub evaluate_hl7 {
  my $logLevel = shift(@_);
  my $verbose = shift(@_);
  my $stdDir  = shift(@_);
  my $stdMsg  = shift(@_);
  my $testDir = shift(@_);
  my $testMsg = shift(@_);
  my $formatFile = shift(@_);
  my $iniFile = shift(@_);
  my $rtnValue = 0;

  print main::LOG "$stdMsg $testMsg \n";

  my $pathStd = "$stdDir/$stdMsg";
  my $pathTest = "$testDir/$testMsg";

  my $evaluateCmd = "$main::MESA_TARGET/bin/hl7_evaluate ";
  $evaluateCmd .= " -l $logLevel ";
  $evaluateCmd .= " -b $main::MESA_TARGET/runtime -m $formatFile $pathTest";

  print main::LOG "$evaluateCmd \n";
  print main::LOG `$evaluateCmd`;
  $rtnValue = 1 if ($?);

  my $compareCmd = "$main::MESA_TARGET/bin/compare_hl7 ";
  $compareCmd .= " -l $logLevel ";
  $compareCmd .= " -b $main::MESA_TARGET/runtime -m $iniFile $pathStd $pathTest";

  print main::LOG "$compareCmd \n";
  print main::LOG `$compareCmd`;

  $rtnValue = 1 if ($?);

  return $rtnValue;
}


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub rm_file {
 my $target = shift( @_);

 if (! (-f $target)) {
  return;
 }

 if( $main::MESA_OS eq "WINDOWS_NT") {
  $target =~ s(/)(\\)g;
  $cmd = "del/Q $target";
 } else {
  $cmd = "rm -f $target";
 }
 print "$cmd\n";
 print `$cmd`;
}

sub create_send_audit {
  my $hostName = shift(@_);
  my $port = shift(@_);
  my $fileSpec = shift(@_);
  my $msgType = shift(@_);

  my $x = "$main::MESA_TARGET/bin/ihe_audit_message -t $msgType $fileSpec.txt $fileSpec.xml ";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "Unable to generate audit message: msgType $fileSpec \n";
    exit(1);
  }
  my $y = "$main::MESA_TARGET/bin/syslog_client -f 10 -s 0 $hostName $port $fileSpec.xml";
  print "$y \n";
  print `$y`;
  if ($?) {
    print "Unable to transmit audit message: $fileSpec \n";
    exit(1);
  }
  print "\n";
}

sub clear_syslog_files {
  my $osName = $main::MESA_OS;

  my $dirName = "$main::MESA_TARGET/logs/syslog";
  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
    `delete/q $dirName\\*.xml`;
  } else {
    `rm -f $dirName/*.xml`;
  }
}

sub extract_syslog_messages() {
 $x = "$main::MESA_TARGET/bin/syslog_extract";
 print "$x \n";
 `$x`;
 if ($?) {
  die "Could not extract syslog messages from database";
 }
}

sub count_syslog_xml_files {
 my $dirName = "$main::MESA_TARGET/logs/syslog";
 opendir SYSLOGDIR, $dirName or die "Could not open directory: $dirName \n";
 @xmlFiles = readdir SYSLOGDIR;
 closedir SYSLOGDIR;

 my $count = 0;
 foreach $f (@xmlFiles) {
  if ($f =~ /.xml/) {
   $count += 1;
  }
 }
 return $count;
}

sub evaluate_all_xml_files {
 my $level = 1;

 my $dirName = "$main::MESA_TARGET/logs/syslog";
 opendir SYSLOGDIR, $dirName or die "Could not open directory: $dirName \n";
 @xmlFiles = readdir SYSLOGDIR;
 closedir SYSLOGDIR;

 my $x = "$main::MESA_TARGET/bin/mesa_xml_eval -l $level ";
 my $rtnValue = 0;
 foreach $f (@xmlFiles) {
  if ($f =~ /.xml/) {
   print main::LOG "\nEvaluating $f\n";
   my $cmd = $x . " $dirName/$f";
   print main::LOG "$cmd \n";
   print main::LOG `$cmd`;
   $rtnValue = 1 if $?;
  }
 }
 return $rtnValue;
}


