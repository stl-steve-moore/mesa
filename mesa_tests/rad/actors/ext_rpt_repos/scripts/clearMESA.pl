#!/usr/local/bin/perl

use Env;
use lib "scripts";
require rptrepos;

print "Clearing MESA Workstation of existing studies.\n";

chdir $MESA_STORAGE;

rptrepos::delete_directory("wkstation");

chdir "$MESA_TARGET/db";
`perl ./ClearImgMgrTables.pl wkstation`;
