#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -r $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_TARGET/logs/of_hl7ps.log

rm -r $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_TARGET/logs/op_hl7ps.log

# MESA Patient Encounter Source
#$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M OF -l $LOGLEVEL -a -z "" 3900 &

# MESA Patient Encounter Consumer
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M OP -l $LOGLEVEL -a -z "" 4100 &
