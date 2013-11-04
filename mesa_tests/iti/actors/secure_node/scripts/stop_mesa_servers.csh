#!/bin/csh

#-#$MESA_TARGET/bin/syslog_client -c localhost 4000 "<SHUTDOWN/>"

$MESA_TARGET/bin/syslog_client -c -r 5424 -x 5426 localhost 4001 "<SHUTDOWN/>"

$MESA_TARGET/bin/syslog_client -c -r 5424 -x TCP  localhost 4002 "<SHUTDOWN/>"

#$MESA_TARGET/bin/syslog_client -c -r 5424 -x 5425 localhost 4003 "<SHUTDOWN/>"

#-set C = $MESA_TARGET/runtime/certificates/test_sys_1.cert.pem
#-set K = $MESA_TARGET/runtime/certificates/test_sys_1.key.pem
#-set P = $MESA_TARGET/runtime/certificates/mesa_list.cert
#-set R = $MESA_TARGET/runtime/certificates/randoms.dat
#-
#-# Order Placer
#-$MESA_TARGET/bin/kill_hl7_secure -C $C -K $K -P $P -R $R localhost 2101
#-
