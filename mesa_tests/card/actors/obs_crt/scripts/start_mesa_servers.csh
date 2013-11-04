#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

#rm -f $MESA_STORAGE/ordfil/hl7/*hl7
rm -f $MESA_STORAGE/rpt_manager/hl7/*hl7

foreach log (imgmgr im_hl7ps of_dcmps of_hl7ps op_hl7ps pp_dcmps \
 rm_hl7ps rpt_manager rpt_repos send_hl7)
  if (-e $MESA_TARGET/logs/$log.log) rm -f $MESA_TARGET/logs/$log.log
endif


#$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z ordfil 2200 &
#$MESA_TARGET/bin/hl7_rcvr -M IM -l $LOGLEVEL -a -z imgmgr 2300 &
#$MESA_TARGET/bin/hl7_rcvr -M IM -l $LOGLEVEL -a -z imgmgr 2800 &
$MESA_TARGET/bin/hl7_rcvr -M RM -l $LOGLEVEL -a -z rpt_manager 2750 &

#$MESA_TARGET/bin/of_dcmps 2250 &

#$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &

#$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/rpt_manager/ds_dcm.cfg &
#$MESA_TARGET/bin/pp_dcmps -n rpt_manager -l $LOGLEVEL 2450 &
