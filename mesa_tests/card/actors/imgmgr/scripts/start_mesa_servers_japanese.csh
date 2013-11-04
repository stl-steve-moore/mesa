#!/bin/csh

if (! $?MESA_IMGMGR_HL7_PORT) then
  echo Some environment variables not set.
  echo Do not run $0 directly. run start_mesa_servers.pl
  exit 1
endif

rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_STORAGE/imgmgr/hl7/*hl7

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/im_hl7ps.log) rm -f $MESA_TARGET/logs/im_hl7ps.log

# Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OFJ -l $LOGLEVEL -a -z ordfil $MESA_OF_HL7_PORT &

# Image Manager
$MESA_TARGET/bin/hl7_rcvr -M IMJ -l $LOGLEVEL -a -z imgmgr $MESA_IMGMGR_HL7_PORT &

$MESA_TARGET/bin/of_dcmps -L Japanese -l $LOGLEVEL $MESA_OF_DICOM_PORT &

$MESA_TARGET/bin/ds_dcm -l $LOGLEVEL -r $MESA_IMGMGR_DICOM_PT $MESA_TARGET/runtime/imgmgr/ds_dcm_japanese.cfg &

$MESA_TARGET/bin/ds_dcm -l $LOGLEVEL -r $MESA_WKSTATION_PORT $MESA_TARGET/runtime/wkstation/ds_dcm_gsps.cfg &

$MESA_TARGET/bin/mod_dcmps -l $LOGLEVEL $MESA_MODALITY_PORT &

$MESA_TARGET/bin/pp_dcmps -l $LOGLEVEL -n imgmgr $MESA_PPM_PORT &

