#!/bin/csh
# Script kills MESA servers started for Patient Demographics Source tests.

# Patient Demographics Consumer
$MESA_TARGET/bin/kill_hl7 localhost 3800

