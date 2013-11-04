#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/rpt_repos/ds_dcm_secure_test.cfg &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/wkstation/ds_dcm_sr.cfg &

$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

