#!/bin/csh

# DSS/OF
#$MESA_TARGET/bin/kill_hl7 localhost 2200
# Image Manager
#$MESA_TARGET/bin/kill_hl7 localhost 2300
# Report Manager
$MESA_TARGET/bin/kill_hl7 localhost 2750
# Observation Repository
#$MESA_TARGET/bin/kill_hl7 localhost 2800

# DSS/OF MWL Server
#$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250
# Image Manager
#$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350
#$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2450

# Report Manager
#$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2700

