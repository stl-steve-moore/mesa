#!/bin/csh

# Script stops the servers used for the Audit Record Repository tests.

$MESA_TARGET/bin/syslog_client -c localhost 4000 SHUTDOWN

