#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_TARGET/logs/syslog_server.log

$MESA_TARGET/bin/syslog_server 4000 &
