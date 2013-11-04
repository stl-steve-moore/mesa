#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

echo "Self test 11250-01 designed for DICOM client applications"
echo "Database used: ordfil"

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA


$MESA_TARGET/bin/cecho_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R -Z $Z localhost 2251

