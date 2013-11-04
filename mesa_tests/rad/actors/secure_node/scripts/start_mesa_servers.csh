#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/syslog_server 4000 &

#if (-e $MESA_TARGET/bin/sdscsyslogd) then
#  echo Starting the SDSC Syslog daemon
#  $MESA_TARGET/bin/sdscsyslogd -c $MESA_TARGET/runtime/syslogd.conf.cooked-file
#  sleep 2
#  $MESA_TARGET/bin/sdscsyslogd -c $MESA_TARGET/runtime/syslogd.conf.udp-cooked
#endif

set C = $MESA_TARGET/runtime/certificates
set CIPHER = NULL-SHA

$MESA_TARGET/bin/tls_server -r -c $CIPHER -v -d -l $LOGLEVEL $C/randoms.dat $C/mesa_1.key.pem $C/mesa_1.cert.pem $C/test_list.cert 4100 >$ $MESA_TARGET/logs/tls_registered.txt &

$MESA_TARGET/bin/tls_server -u -c $CIPHER -d -l $LOGLEVEL $C/randoms.dat $C/unregistered.key $C/unregistered.cert $C/test_list.cert 4101 >$ $MESA_TARGET/logs/tls_unregistered.txt &

$MESA_TARGET/bin/tls_server -e -c $CIPHER -d -l $LOGLEVEL $C/randoms.dat $C/expired.key $C/expired.cert $C/test_list.cert 4102 >$ $MESA_TARGET/logs/tls_expired.txt &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/imgmgr/ds_dcm_secure_mesa.cfg &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/imgmgr/ds_dcm_secure_mesa_unregistered.cfg &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/imgmgr/ds_dcm_secure_mesa_expired.cfg &
