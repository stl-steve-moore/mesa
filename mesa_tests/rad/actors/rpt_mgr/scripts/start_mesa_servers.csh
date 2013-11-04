#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_STORAGE/imgmgr/hl7/*hl7
rm -f $MESA_STORAGE/chgp/hl7/*hl7

foreach log (imgmgr op_hl7ps of_hl7ps im_hl7ps cp_hl7ps)
  if (-e $MESA_TARGET/logs/$log.log) rm -f $MESA_TARGET/logs/$log.log
end

$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z ordplc 2100 &
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z ordfil 2200 &
$MESA_TARGET/bin/hl7_rcvr -M IM -l $LOGLEVEL -a -z imgmgr 2300 &
$MESA_TARGET/bin/hl7_rcvr -M RM -l $LOGLEVEL -a -z rpt_manager 2750 &
$MESA_TARGET/bin/hl7_rcvr -M OP -l $LOGLEVEL -a -z "" 3300 &

$MESA_TARGET/bin/of_dcmps 2250 &
#
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &

$MESA_TARGET/bin/pp_dcmps -n rpt_manager -l $LOGLEVEL 2450 &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/rpt_manager/ds_dcm.cfg &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/rpt_repos/ds_dcm.cfg &



