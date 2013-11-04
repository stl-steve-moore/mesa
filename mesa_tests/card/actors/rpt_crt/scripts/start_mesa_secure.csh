#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

if (-e $MESA_TARGET/logs/rm_hl7ps.log) rm -f $MESA_TARGET/logs/rm_hl7ps.log

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/rpt_manager/ds_dcm_secure_mesa.cfg &

$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

