#!/usr/local/bin/perl -w

# Package for Secure Node scripts.

use Env;

package secure;
require Exporter;
#@ISA = qw(Exporter);
#
#@EXPORT = qw(
#);

sub read_config_params {
  open (CONFIGFILE, "secure_test.cfg") or die "Can't open secure_test.cfg.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }
  my $syslogPortMESA = $varnames{"MESA_SYSLOG_PORT"};

  my $syslogHostTest = $varnames{"TEST_SYSLOG_HOST"};
  my $syslogPortTest = $varnames{"TEST_SYSLOG_PORT"};

  my $secureServerHostTest = $varnames{"TEST_SECURE_SERVER_HOST"};
  my $secureServerPortTest = $varnames{"TEST_SECURE_SERVER_PORT"};

  return ($syslogPortMESA,
	  $syslogHostTest, $syslogPortTest,
	  $secureServerHostTest, $secureServerPortTest);
}

sub audit_message_error {
  my $msg = shift(@_);

  print "Unable to generate audit message for $msg \n";
  exit 1;
}


sub transmit_error {
  my $msg = shift(@_);
  my $hostName = shift(@_);
  my $port = shift(@_);

  print "Unable to transmit message: $msg to host:port $hostName:$port \n";
  exit 1;
}

sub tls_connect_error {
  my $hostName = shift(@_);
  my $port = shift(@_);

  print "Unable to establish TLS connection. \n" .
	" host = $hostName, port = $port \n";

  exit 1;
}

# OS-neutral file delete.
sub rm_file {
   my $target = shift( @_);

   if( $main::MESA_OS eq "WINDOWS_NT") {
      $target =~ s(/)(\\)g;
      $cmd = "del/Q $target";
   }
   else {
      $cmd = "rm -f $target";
   }
   print "$cmd\n";
   `$cmd`;
}

sub validate_xml_schema {
  my $level = shift(@_);
  my $auditFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $auditFile\n";
  print main::LOG "\nEvaluating $auditFile\n";
  my $x = "$main::MESA_TARGET/bin/mesa_xml_eval ";
  $x .= " -l $level ";
  $x .= " $auditFile";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print main::LOG "Audit Record (Actor-config) $auditFile does not pass evaluation.\n";
  }

  return $rtnValueEval;
}

sub validate_atna_xml_schema {
  my $level = shift(@_);
  my $auditFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $auditFile\n";
  print main::LOG "\nEvaluating $auditFile\n";
  my $schema = "$main::MESA_TARGET/runtime/IHE-ATNA-syslog-audit-message.xsd";
  my $x = "$main::MESA_TARGET/bin/mesa_xml_eval ";
  $x .= " -l $level ";
  $x .= " -s $schema ",
  $x .= " $auditFile";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print main::LOG "Audit Record (Actor-config) $auditFile does not pass evaluation.\n";
  }

  return $rtnValueEval;
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

