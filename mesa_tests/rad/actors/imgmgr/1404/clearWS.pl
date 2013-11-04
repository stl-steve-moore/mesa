#!/usr/local/bin/perl

use Env;
use lib "scripts";
require imgmgr;

print "Clearing MESA Workstation\n";

chdir $MESA_STORAGE;

mesa::delete_directory(1,"wkstation");

chdir "$MESA_TARGET/db";
`perl ./ClearImgMgrTables.pl wkstation`;
