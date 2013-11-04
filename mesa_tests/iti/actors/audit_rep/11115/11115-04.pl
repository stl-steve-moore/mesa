#!/usr/local/bin/perl -w


# Audit Repository test 11115-04

use Env;
use lib "../../../common/scripts";
require mesa_common;
require mesa_utility;


$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

# Main starts here

my $y = scalar(@ARGV);
die "Usage: perl 11115/11115-04.pl host port\
 This application is for testing RFC 5424/5426\
 localhost 4001 for self test\n    " if ($y != 2);

my $host = $ARGV[0];
my $port = $ARGV[1];

$x = "$MESA_TARGET/bin/ihe_audit_message -t ATNA_STARTUP 11115/atna_startup.txt 11115/atna_startup.xml ";
print "$x \n";
print `$x`;


#my $C = "$MESA_TARGET/runtime/certs-ca-signed/mesa_1.cert.pem";
#my $K = "$MESA_TARGET/runtime/certs-ca-signed/mesa_1.key.pem";
#my $P = "$MESA_TARGET/runtime/certs-ca-signed/test_list.cert";
#my $R = "$MESA_TARGET/runtime/certs-ca-signed/randoms.dat";

mesa_utility::delete_file(4, "$MESA_TARGET/logs/syslog/last_log.xml");
mesa_utility::delete_file(4, "$MESA_TARGET/logs/syslog/last_log.txt");

$x = "$MESA_TARGET/bin/syslog_client -f 10 -s 5 -r 5424 -x 5426 $host $port  11115/atna_startup.xml";

print "$x \n";
print `$x`;

die "Transmit error" if $?;

goodbye;

