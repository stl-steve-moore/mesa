#!/bin/csh

# shell script starts servers for Evidence Creator tests

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordfil/hl7/*

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log


# DICOM applications
# Image Manager
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &

# Workstation
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/wkstation/ds_dcm_gsps.cfg &


