#!/bin/csh
# Script kills MESA servers started for Patient Encounter Consumer tests.

# MESA Patient Encounter Source
#$MESA_TARGET/bin/kill_hl7 localhost 3900

# MESA Patient Encounter Consumer
$MESA_TARGET/bin/kill_hl7 localhost 4000

