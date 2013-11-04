#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordplc/*hl7
rm -f $MESA_STORAGE/ordfil/*hl7

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/op_hl7ps.log) rm -f $MESA_TARGET/logs/op_hl7ps.log

set C = $MESA_TARGET/runtime/certificates/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certificates/mesa_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M OP -C $C -K $K -P $P -R $R -a -z ordplc 2100 &

set C = $MESA_TARGET/runtime/certificates/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certificates/test_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M OF -C $C -K $K -P $P -R $R -a -z "" 2200 &

$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

