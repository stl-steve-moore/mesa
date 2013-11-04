#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -r $MESA_STORAGE/pd_supplier/*hl7
rm -r $MESA_STORAGE/ordfil/*hl7

# PD Supplier
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M PDS -l $LOGLEVEL -a -z pd_supplier 3700 &

# MESA PD_PAM Consumer
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M OF -l $LOGLEVEL -a -z "" 3800 &
