#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/op_hl7ps.log) rm -f $MESA_TARGET/logs/op_hl7ps.log

# Order Placer
$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z ordplc 2100 &

# Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z "" 2200 &

