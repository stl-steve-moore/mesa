# This script creates all MESA database tables (SQL Server)

if (scalar(@ARGV) != 3) {
  print "This script takes three arguments: <login> <password> <server> \n";
  print "The login/password can be for the sa account or another account.\n";
  print "The <server> value is passed to isql with the -S switch.\n";
  exit 1;
}

$login = $ARGV[0];
$passwd = $ARGV[1];
$server = $ARGV[2];


print `.\\CreateADTTables.bat adt $login $passwd $server`;

print `.\\CreateOrdPlcTables.bat ordplc $login $passwd $server`;

print `.\\CreateOrdFilTables.bat ordfil $login $passwd $server`;

print `.\\CreateModTables.bat mod1 $login $passwd $server`;

print `.\\CreateModTables.bat mod2 $login $passwd $server`;

print `.\\CreateImgMgrTables.bat expmgr $login $passwd $server`;

print `.\\CreateImgMgrTables.bat exprcr $login $passwd $server`;

print `.\\CreateImgMgrTables.bat imgmgr $login $passwd $server`;

print `.\\CreateImgMgrTables.bat wkstation $login $passwd $server`;

print `.\\CreateImgMgrTables.bat rpt_repos $login $passwd $server`;

print `.\\CreateImgMgrTables.bat rpt_manager $login $passwd $server`;

print `.\\CreateSyslogTables.bat syslog $login $passwd $server`;

print `.\\CreateInfoSrcTables.bat info_src $login $passwd $server`;

print `.\\CreateXRefMgrTables.bat xref_mgr $login $passwd $server`;

print `.\\CreateXRefMgrTables.bat pd_supplier $login $passwd $server`;