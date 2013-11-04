#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/syslog_server 4000 &

set C = $MESA_TARGET/runtime/certificates
set CIPHER = NULL-SHA

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/imgmgr/ds_dcm_secure_test.cfg &
