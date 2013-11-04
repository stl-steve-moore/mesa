#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA

#$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

echo "Starting 5424 / 5426 UDP 4001 "
$MESA_TARGET/bin/syslog_server -l $LOGLEVEL -r 5424 -x 5426 4001 &

echo "Starting 5424 / TCP  TCP 4002 "
$MESA_TARGET/bin/syslog_server -l $LOGLEVEL -r 5424 -x TCP  4002 &

echo "Starting 5424 / 5425 TLS 4003 "
$MESA_TARGET/bin/syslog_server_secure -l $LOGLEVEL -r 5424 -x 5425 -C $C -K $K -P $P -R $R -Z $Z 4003 &

