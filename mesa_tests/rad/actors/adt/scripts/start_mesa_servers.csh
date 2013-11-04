#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_TARGET/logs/of_hl7ps.log $MESA_TARGET/logs/op_hl7ps.log

# Order Placer
$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z "" 2100 &

# Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z ordfil 2200 &

# Charge Processor
$MESA_TARGET/bin/hl7_rcvr -M CP -l $LOGLEVEL -a -z "" 2150 &
