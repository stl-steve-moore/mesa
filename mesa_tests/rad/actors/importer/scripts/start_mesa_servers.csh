#!/bin/csh

# shell script starts servers for MEDIA IMPORTER tests

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordfil/hl7/*

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log

# HL7 applications
#  Portable Media Importer
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z ordfil 2200 &

# DICOM applications
#
$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/imgmgr/ds_dcm.cfg &
# Order Filler
$MESA_TARGET/bin/of_dcmps 2250 &


