#!/usr/local/bin/perl -w

# General package for MESA scripts.
# This file contains scripts to transmit messages.

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# Usage: send_hl7_log(loglevel, msg directory, file name, target host, target port)
# Returns:
#  0 on success
#  1 on failure

sub send_hl7_log {
  my ($logLevel, $hl7Dir, $msg, $target, $port)  = @_;

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe-iti ";

  $x = "$send_hl7 -l $logLevel ";
  $x .= "-c " if ($logLevel) >= 3;
  $x .= " $target $port $hl7Dir/$msg";
  print "$x\n" if ($logLevel >= 3);
  print `$x`;

  return 1 if $?;

  return 0;
}

# Usage: send_hl7_capture(loglevel, msg directory, file name,
#	target host, target port, output file)
# Returns:
#  0 on success
#  1 on failure

sub send_hl7_capture {
  my ($logLevel, $hl7Dir, $msg, $target, $port, $outputFile)  = @_;

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe-iti -C $outputFile";

  $x = "$send_hl7 -l $logLevel ";
  $x .= " $target $port $hl7Dir/$msg";
  print "$x\n" if ($logLevel >= 3);
  print `$x`;

  return 1 if $?;

  return 0;
}

# Usage: send_hl7_pdq_query(loglevel, msg directory, file name,
#	target host, target port, output file)
# Returns:
#  0 on success
#  1 on failure

sub send_hl7_pdq_query {
  my ($logLevel, $hl7Dir, $msg, $target, $port, $outputBase)  = @_;

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -Q -d ihe-iti -C $outputBase";

  $x = "$send_hl7 -l $logLevel ";
  $x .= " $target $port $hl7Dir/$msg";
  print "$x\n" if ($logLevel >= 3);
  print `$x`;

  return 1 if $?;

  return 0;
}

# Usage: xmit_error(file name)

# Usage: xmit_error(file name)
# Prints an error message and exits
# Returns: never

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}


1;
