#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/rpt_repos/ds_dcm_japanese.cfg &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/wkstation/ds_dcm_sr_japanese.cfg &
