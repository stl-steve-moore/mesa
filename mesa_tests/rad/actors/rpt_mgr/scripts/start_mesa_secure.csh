#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/rpt_repos/ds_dcm_secure_mesa.cfg &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/rpt_manager/ds_dcm_secure_test.cfg &

$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z "" 3300 &

# MESA Audit Record Repository
$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

