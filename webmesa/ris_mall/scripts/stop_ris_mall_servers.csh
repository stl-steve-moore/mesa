#!/bin/csh

$MESA_TARGET/bin/kill_hl7 localhost 4100
$MESA_TARGET/bin/kill_hl7 localhost 4200

$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 4250

