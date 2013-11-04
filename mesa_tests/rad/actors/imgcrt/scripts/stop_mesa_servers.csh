#!/bin/csh

# Order Filler
$MESA_TARGET/bin/kill_hl7 localhost 2200

# Image Manager
$MESA_TARGET/bin/kill_hl7 localhost 2300

# Order Filler
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250

# Image Manager
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

# Workstation
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 3001

# Modality
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2400

# Post Processing Manager
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2450

