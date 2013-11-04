#!/bin/csh

set LOGLEVEL=0

if ($1 != "") then
  set LOGLEVEL = $1
endif

echo Log Level: $LOGLEVEL

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_TARGET/logs/of_hl7ps.log $MESA_TARGET/logs/op_hl7ps.log

set C = $MESA_TARGET/runtime/certificates/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certificates/test_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M OP -a -z ordplc -C $C -K $K -P $P -R $R 2100 &
$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M OF -a -z ordfil -C $C -K $K -P $P -R $R 2200 &

$MESA_TARGET/bin/syslog_server -d syslog 4000 &
