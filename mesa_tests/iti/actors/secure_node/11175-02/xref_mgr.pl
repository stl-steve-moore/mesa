#!/usr/local/bin/perl -w

# Runs test 11175-01

use Env;
use lib "scripts";

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}

sub send_hl7_secure {
  my ($logLevel, $host, $port, $selfTest) = @_;

  my ($c, $k, $p, $r);
  if ($selfTest == 0) {
    $c = "$MESA_TARGET/runtime/certs-ca-signed/mesa_1.cert.pem";
    $k = "$MESA_TARGET/runtime/certs-ca-signed/mesa_1.key.pem";
    $p = "$MESA_TARGET/runtime/certs-ca-signed/test_list.cert";
    $r = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";
  } else {
    $c = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem";
    $k = "$MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem";
    $p = "$MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert";
    $r = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";
  }
  unlink "$MESA_TARGET/logs/send_hl7_secure.log" if (-e "$MESA_TARGET/logs/send_hl7_secure.log");

  my $f = "../../../iti/msgs/qbp/10501/10501.108.q23.hl7";
  my $x = "$MESA_TARGET/bin/send_hl7_secure -l $logLevel -d ihe-iti -C $c -K $k -P $p -R $r $host $port $f";
  print "$x\n";
  print `$x`;
}

# Main starts here

die "Usage: <host> <port>\n" if (scalar(@ARGV) < 2);

my $host = $ARGV[0];
my $port = $ARGV[1];
my $logLevel = 4;

$selfTest = 0;
$selfTest = 1 if (scalar(@ARGV) > 2);

send_hl7_secure($logLevel, $host, $port, $selfTest);
