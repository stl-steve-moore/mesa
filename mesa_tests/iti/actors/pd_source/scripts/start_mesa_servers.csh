#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -r $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_TARGET/logs/of_hl7ps.log

# Patient Demographics Consumer
$MESA_TARGET/bin/hl7_rcvr -d ihe-iti -M OF -l $LOGLEVEL -a -z "" 3800 &

