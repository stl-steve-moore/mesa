#!/bin/csh

# Order Filler
$MESA_TARGET/bin/kill_hl7 localhost $MESA_OF_HL7_PORT

# Image Manager
$MESA_TARGET/bin/kill_hl7 localhost $MESA_IMGMGR_HL7_PORT 

# Order Filler
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $MESA_OF_DICOM_PORT

# Image Manager
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $MESA_IMGMGR_DICOM_PT

# Workstation
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $MESA_WKSTATION_PORT

# Modality
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $MESA_MODALITY_PORT

# Post Processing Manager
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost $MESA_PPM_PORT

