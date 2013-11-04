# Test Case 11531: PWP Query Key 2
#
#use Net::LDAP;
#use Net::LDAP::LDIF;
#use Time::Local;
#use lib "scripts";
#require pwp;

$SIG{INT} = \&end_Program;

sub end_Program {
  exit 0;
}

#*** CREATING LDIF, Search and Add Each Entry to a File *****
sub doQuery{
  $ldif = Net::LDAP::LDIF->new( "./11531/11531.log", "w", onerror => 'undef' );
  $recordNo = 1;
  $msg = $ldap->search(filter=>("(o=IHE Network)" and "(ou=Librarians)"), base=>$pwpLDIFBase);
  @entries = $msg->entries;
  foreach $entry (@entries) {
        print FILEHANDLE "\nWriting entry $recordNo \n";
        print "\nWriting entry $recordNo.\n";
        $recordNo++;
        $ldif->write_entry($entry);
  }   
  $ldif->done();
  print "Close LDIF";
  print FILEHANDLE "Close LDIF";
}  
#****************************************************

die "Do not run this script; this has been retired; please read the test instructions in the documentation";

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

open (FILEHANDLE, ">./11531/pwp_11531_log.txt") or die "no such file";
print FILEHANDLE "Test Number: 11531 \nPort Number: $pwpPortTest \nRecorded at: ", $timenow;
print FILEHANDLE "\n\nTrying to connect to your LDAP server via anonymous authentication.\n";
print "\n\nTrying to connect to your LDAP server via anonymous authentication.\n";

$ldap = Net::LDAP->new($pwpHostTest,port=>$pwpPortTest,timeout=>$pwpTimeoutTest,verion=>$pwpVersionTest);
# Anonymous authentication.
$ldapMsg = $ldap->bind;

if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nAnonymous authentication successful with ", $pwpHostTest, ".\n";
    print FILEHANDLE "\nAnonymous authentication successful with ", $pwpHostTest, ".\n";
    doQuery;
} else {
    print "\nAnonymous authentication fail.\n";
    print FILEHANDLE "\nAnonymous authentication fail.\n";
}

# Disconnecting with LDAP server.
$ldapMsg = $ldap->unbind();
if ($ldapMsg->code == LDAP_SUCCESS) {
    print "\nClose session successful.\n\n";
    print FILEHANDLE "\nClose session successful.\n\n";
}

close (FILEHANDLE);

end_Program;
