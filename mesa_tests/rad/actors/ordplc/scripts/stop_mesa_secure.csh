#!/bin/csh

# These are files we need for certificates, etc., for secure servers

set C = $MESA_TARGET/runtime/certificates/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certificates/test_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R localhost 2100

set C = $MESA_TARGET/runtime/certificates/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certificates/mesa_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R localhost 2200

# Audit Record Repository
$MESA_TARGET/bin/syslog_client -c localhost 4000 SHUTDOWN

