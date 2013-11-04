# This script drops all MESA database tables (SQL Server)

if (scalar(@ARGV) != 3) {
  print "This script takes three arguments: <login> <password> <server>\n";
  print "The login/password can be for the sa account or another account.\n";
  print "The <server> value is passed to isql with the -S switch.\n";
  exit 1;
}

$login = $ARGV[0];
$passwd = $ARGV[1];
$server = $ARGV[2];


print `.\\DropADTTables.bat adt $login $passwd $server`;

print `.\\DropOrdPlcTables.bat ordplc $login $passwd $server`;

print `.\\DropOrdFilTables.bat ordfil $login $passwd $server`;

print `.\\DropModTables.bat mod1 $login $passwd $server`;

print `.\\DropModTables.bat mod2 $login $passwd $server`;

print `.\\DropImgMgrTables.bat expmgr $login $passwd $server`;

print `.\\DropImgMgrTables.bat exprcr $login $passwd $server`;

print `.\\DropImgMgrTables.bat imgmgr $login $passwd $server`;

print `.\\DropImgMgrTables.bat wkstation $login $passwd $server`;

print `.\\DropImgMgrTables.bat rpt_repos $login $passwd $server`;

print `.\\DropImgMgrTables.bat rpt_manager $login $passwd $server`;

print `.\\DropSyslogTables.bat syslog $login $passwd $server`;

print `.\\DropInfoSrcTables.bat info_src $login $passwd $server`;

print `.\\DropXRefMgrTables.bat xref_mgr $login $passwd $server`;

print `.\\DropXRefMgrTables.bat pd_supplier $login $passwd $server`;
