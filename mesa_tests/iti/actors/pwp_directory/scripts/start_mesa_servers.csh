#!/bin/csh

# This script starts servers needed to test the PWP Directory.

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

# PWP Directory
#$MESA_TARGET/bin/xxxxxxxx $LOGLEVEL 3800 &
slapd -f /opt/mesa/runtime/ldap/slapd.conf -d 1

