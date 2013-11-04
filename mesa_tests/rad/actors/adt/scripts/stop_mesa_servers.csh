#!/bin/csh
# Script kills MESA servers started for ADT test.

# Order Placer
$MESA_TARGET/bin/kill_hl7 localhost 2100

#Order Filler
$MESA_TARGET/bin/kill_hl7 localhost 2200

#Charge Processor
$MESA_TARGET/bin/kill_hl7 localhost 2150

