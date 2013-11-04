#!/bin/csh

set LOGLEVEL=1

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -r $MESA_STORAGE/pd_supplier/*hl7

# PD Supplier
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M PDS -l $LOGLEVEL -a -z pd_supplier 3700 &

