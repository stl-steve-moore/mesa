# Test Case 11510: PWP Anonymous Authentication
#
use Net::LDAP;
use Time::Local;
use lib "scripts";
require pwp;

$SIG{INT} = \&end_Program;

sub end_Program {
  exit 0;
}

die "Usage: <output level: 0-4>\n" if (scalar(@ARGV) < 1);


$timenow = localtime;

($pwpHostTest,$pwpPortTest, $pwpSSLTest, $pwpDNTest, $pwpPasswordTest, 
 $pwpVersionTest, $pwpTimeoutTest, $pwpLDIFFilename, $pwpLDIFWriteFilename,
 $pwpLDIFBase) = pwp::read_config_params();

print "Illegal Test Host name: $pwpHostTest \n" if ($pwpHostTest eq "");
print "Illegal Test Port number: $pwpPortTest \n" if ($pwpPortTest == 0);
print "Illegal Test SSL Port: $pwpSSLTest \n" if ($pwpSSLTest  == 0);
print "Illegal Test DN: $pwpDNTest \n" if ($pwpDNTest eq "");
print "Illegal Test Password: $pwpPasswordTest \n" if ($pwpPasswordTest eq "");
print "Illegal Test LDAP Version: $pwpVersionTest \n" if (($pwpVersionTest  > 3) || ($pwpVersionTest < 2));
print "Illegal Test Timeout: $pwpTimeoutTest \n" if ($pwpTimeoutTest < 0);
print "Illegal Test LDIF INPUT FILENAME: $pwpLDIFFilename \n" if ($pwpLDIFFilename eq "");
print "Illegal Test LDIF OUTPUT FILENAME: $pwpLDIFWriteFilename \n" if ($pwpLDIFWriteFilename eq "");
print "Illegal Test LDIF BASE: $pwpLDIFBase \n" if ($pwpLDIFBase eq "");

open (FILEHANDLE, ">./pwp_11510_log.txt") or die "no such file";
print FILEHANDLE "Test Number: 11510 \nPort Number: $pwpPortTest \nRecorded at: ", $timenow;
print FILEHANDLE "\n\nTrying to connect to your LDAP server via anonymous authentication.\n";
print "\n\nTrying to connect to your LDAP server via anonymous authentication.\n";

$ldap = Net::LDAP->new($pwpHostTest,port=>$pwpPortTest,timeout=>$pwpTimeoutTest,verion=>$pwpVersionTest);
#$ldap = Net::LDAP->new($pwpHostTest);
$ldapMsg = $ldap->bind;
$ldapMsg->code && die $ldapMsg->error;
 
warn $ldapMsg->error if $ldapMsg->code != LDAP_SUCCESS;

if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nAnonymous authentication successful with ", $pwpHostTest, ".\n";
    print FILEHANDLE "\nSimple authentication successful with ", $pwpHostTest, ".\n";
} else {
    print "\nAnonymous authentication fail.\n";
    print FILEHANDLE  "\nAnonymous authentication fail.\n";
}

# Disconnecting with LDAP server.
$ldapMsg = $ldap->unbind();
if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nClose session successful.\n\n";
    print FILEHANDLE "\nClose session successful.\n\n";
}

close (FILEHANDLE);

end_Program;