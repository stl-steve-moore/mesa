#!/usr/local/bin/perl -w

# Package for Audit Record Repository scripts.

use Env;

package audit;
require Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(
);

sub read_config_params {
  open (CONFIGFILE, "audit_test.cfg") or die "Can't open audit_test.cfg.\n";
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

  return ($syslogPortMESA,
	  $syslogHostTest, $syslogPortTest);
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

1;
