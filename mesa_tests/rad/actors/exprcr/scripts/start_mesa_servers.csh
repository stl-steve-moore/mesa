#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

if (-e $MESA_TARGET/logs/em_hl7ps.log) rm -f $MESA_TARGET/logs/em_hl7ps.log

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/expmgr/ds_dcm.cfg &
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/exprcr/ds_dcm.cfg &
