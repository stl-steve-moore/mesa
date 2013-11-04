#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1


$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/rpt_repos/ds_dcm.cfg &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &

