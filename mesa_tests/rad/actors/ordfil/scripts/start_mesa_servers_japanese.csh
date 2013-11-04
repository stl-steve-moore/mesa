#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_STORAGE/imgmgr/hl7/*hl7
rm -f $MESA_STORAGE/chgp/hl7/*hl7

if (-e $MESA_TARGET/logs/op_hl7ps.log) rm -f $MESA_TARGET/logs/op_hl7ps.log
if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/im_hl7ps.log) rm -f $MESA_TARGET/logs/im_hl7ps.log
if (-e $MESA_TARGET/logs/cp_hl7ps.log) rm -f $MESA_TARGET/logs/cp_hl7ps.log


# Order Placer
$MESA_TARGET/bin/hl7_rcvr -M OPJ -l $LOGLEVEL -a -z ordplc 2100 &

# Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OFJ -l $LOGLEVEL -a -z ordfil 2200 &

# Image Manager
$MESA_TARGET/bin/hl7_rcvr -M IMJ -l $LOGLEVEL -a -z imgmgr 2300 &

$MESA_TARGET/bin/of_dcmps -L Japanese 2250 &
#
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm_japanese.cfg &

$MESA_TARGET/bin/pp_dcmps -n ordfil 2450 &

# MESA Charge Processor
$MESA_TARGET/bin/hl7_rcvr -M CP -l $LOGLEVEL -a -z "" 2150 &

