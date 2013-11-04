#!/usr/local/bin/perl -w


# Self test for test 11115.

use Env;
use File::Copy;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$x = "$MESA_TARGET/bin/ihe_audit_message -t STARTUP 11115/startup.txt 11115/startup.xml ";
$x = "$MESA_TARGET/bin/ihe_audit_message -t ATNA_STARTUP 11115/atna_startup.txt 11115/atna_startup.xml ";
print "$x \n";
print `$x`;

my $x = "echo \"check command line parameters, should be ('', 5425, 5426)\"";

my $y = scalar(@ARGV);

my $C = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem";
my $K = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem";
my $P = "$MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert";
my $R = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";

if ($y == 0) {
  $x = "$MESA_TARGET/bin/syslog_client -f 10 -s 5 -t PID localhost 4000 11115/atna_startup.xml";
} elsif ($ARGV[0] eq "5425") {
  $x = "$MESA_TARGET/bin/syslog_client -f 10 -s 5 -r 5424 -x 5425 -C $C -K $K -P $P -R $R localhost  4003 11115/atna_startup.xml";
} elsif ($ARGV[0] eq "5426") {
  $x = "$MESA_TARGET/bin/syslog_client -f 10 -s 5 -r 5424 -x 5425 -C $C -K $K -P $P -R $R localhost  4001 11115/atna_startup.xml";
}

print "$x \n";
print `$x`;

die "Transmit error" if $?;

goodbye;

