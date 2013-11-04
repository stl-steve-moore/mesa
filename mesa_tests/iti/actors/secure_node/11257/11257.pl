#!/usr/bin/perl -w

# Script for test 11257, Audit Record with TLS

use Env;
use File::Copy;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

sub usage {
  print "Usage: perl 11257/11257.pl host port\n";
  print " host     Your host or IP address\n";
  print " port     Your receiving port\n";
}

if (scalar(@ARGV) != 2) {
  usage();
  exit();
}

my $host = $ARGV[0];
my $port = $ARGV[1];

my $C = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem";
my $K = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem";
my $P = "$MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert";
my $R = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";
my $Z = "AES128-SHA";

$x = "$MESA_TARGET/bin/ihe_audit_message -t STARTUP 11114/startup.txt 11114/startup.xml";
$x = "$MESA_TARGET/bin/ihe_audit_message -t ATNA_STARTUP 11114/atna_startup.txt 11114/atna_startup.xml ";
print "$x \n";
print `$x`;

$x = "$MESA_TARGET/bin/syslog_client_secure -l 4 -f 10 -s 5 -r 5424 -x 5425 -C $C -K $K -P $P -R $R -Z $Z $host $port 11114/atna_startup.xml";

print "$x \n";
print `$x`;

goodbye;

