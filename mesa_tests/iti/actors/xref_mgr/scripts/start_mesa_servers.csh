#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -r $MESA_STORAGE/xref/*hl7
rm -f $MESA_TARGET/logs/op_hl7ps.log

# XRef Manager
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M XR -l $LOGLEVEL -a -z xref_mgr 3600 &

