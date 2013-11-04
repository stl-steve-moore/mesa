#!/bin/csh
# Script kills MESA servers started for Patient Demographics Supplier tests

# PD Supplier
$MESA_TARGET/bin/kill_hl7 localhost 3700

# MESA Patient Demographics Consumer
$MESA_TARGET/bin/kill_hl7 localhost 3800
