#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7

if (-e $MESA_TARGET/logs/op_hl7ps.log) rm -f $MESA_TARGET/logs/op_hl7ps.log
if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/of_dcmps.log) rm -f $MESA_TARGET/logs/of_dcmps.log

# Order Placer
$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z webop 4100 &

# Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z webof 4200 &

# Order Filler DICOM Server (MWL, PPS)
$MESA_TARGET/bin/of_dcmps -D webof 4250 &

