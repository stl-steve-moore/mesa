#!/bin/csh

# Report Repository
set C = $MESA_TARGET/runtime/certificates/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certificates/test_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat
$MESA_TARGET/bin/open_assoc_secure -C $C -K $K -P $P -R $R -s 0 -x 1.2.840.113654.2.30.1 localhost 2800

# Workstation
$MESA_TARGET/bin/open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 3001

# Audit Record Repository
$MESA_TARGET/bin/syslog_client -c localhost 4000 SHUTDOWN
