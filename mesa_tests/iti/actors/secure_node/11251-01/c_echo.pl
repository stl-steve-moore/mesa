#!/usr/bin/perl -w


# Script for test 11251-01, DICOM C-Echo with certificates

use Env;
use File::Copy;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

sub usage {
  print "Usage: perl 11251-01/c_echo.pl AE-title host port\n";
  print " AE-title Your DICOM AE title\n";
  print " host     Your host or IP address\n";
  print " port     Your receiving port\n";
}

if (scalar(@ARGV) != 3) {
  usage();
  exit();
}

my $AE   = $ARGV[0];
my $host = $ARGV[1];
my $port = $ARGV[2];

my $C = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem";
my $K = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem";
my $P = "$MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert";
my $R = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";
my $Z = "AES128-SHA";

$x = "$MESA_TARGET/bin/cecho_secure -l 4 -C $C -K $K -P $P -R $R -Z $Z -c $AE $host $port";

print "$x \n";
print `$x`;

goodbye;

