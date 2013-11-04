# Test Case 11512: PWP SSL Authentication
#

use Net::LDAP;
use Net::LDAPS;
use Time::Local;
use lib "scripts";
require pwp;

$SIG{INT} = \&end_Program;

sub end_Program {
  exit 0;
}

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

open (FILEHANDLE, ">./11512/pwp_11512_log.txt") or die "no such file";
print FILEHANDLE "Test Number: 11512 \nPort Number: $pwpPortTest \nRecorded at: ", $timenow;
print FILEHANDLE "\n\nTrying to connect to your LDAP server via SSL authentication.\n";
print "\n\nTrying to connect to your LDAP server via SSL authentication.\n";

$ldaps = Net::LDAPS->new($pwpHostTest) or  die "$@";
$ldapMsg = $ldaps->bind($pwpDNTest, password=>$pwpPasswordTest);

if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nSSL authentication successful with ", $pwpHostTest, ".\n";
    print FILEHANDLE "\nSimple authentication successful with ", $pwpHostTest, ".\n";
} else {
    print "\nSSL authentication fail.\n";
    print FILEHANDLE "\nSimple authentication fail.\n";
}

# Disconnecting with LDAP server.
$ldapMsg = $ldaps->unbind();
if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nClose session successful.\n\n";
    print FILEHANDLE "\nClose session successful.\n\n";
}

close (FILEHANDLE);

end_Program;
