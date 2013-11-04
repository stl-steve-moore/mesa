#!/usr/local/bin/perl

# allow the script to be started from the scripts directory,
# but "cd .." if it is.
use Cwd;
$dir = cwd;
if ($dir =~ /scripts$/) {
  chdir "..";
}

use Env;
use lib "scripts";
require imgmgr;

print "Clearing MESA Order Filler and Image Manager of existing studies.\n";

chdir $MESA_STORAGE;

mesa::delete_directory(1,"imgmgr");

if( chdir "modality") {
    mesa::delete_directory(1,"st_comm");
}

chdir "$MESA_TARGET/db";
`perl ./ClearImgMgrTables.pl imgmgr`;
`perl ./load_apps.pl imgmgr`;
`perl ./ClearOrdFilContent.pl ordfil`;
`perl ./ClearSyslogTables.pl syslog`;
