# This script loads the MESA database tables used
# for MESA-ITI tests. This is for SQL Server 2000.

if (scalar(@ARGV) != 3) {
  print "This script takes three arguments: <login> <password> <server> \n";
  print "The login/password can be for the san account or another account.\n";
  print "The <server> value is passed to isql with the -S switch.\n";
  exit 1;
}

$login = $ARGV[0];
$passwd = $ARGV[1];
$server = $ARGV[2];

@names = (
	"load_rid_data.sql", "info_src",
	"load_doc_reference.sql", "info_src",
	);

$idx = 0;

while ($idx < scalar(@names)) {
  $scriptName = $names[$idx];
  $dbName     = $names[$idx+1];
  $idx += 2;
  $x = "osql -E -S $server -d $dbName < sqlfiles\\$scriptName";
  print "$x\n";
  print `$x`;
}
