#!/bin/csh

# Script starts MESA servers used for Charge Processor tests.

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/chgp/hl7/*hl7

if (-e $MESA_TARGET/logs/cp_hl7ps.log) rm -f $MESA_TARGET/logs/cp_hl7ps.log

# MESA Charge Processor
$MESA_TARGET/bin/hl7_rcvr -M CP -l $LOGLEVEL -a -z "" 2150 &

# MESA Order Filler
$MESA_TARGET/bin/hl7_rcvr -M OF -l $LOGLEVEL -a -z "ordfil" 2200 &

