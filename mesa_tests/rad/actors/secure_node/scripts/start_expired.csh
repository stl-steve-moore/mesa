#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

$MESA_TARGET/bin/syslog_server 4000 &

set C = $MESA_TARGET/runtime/certificates
set CIPHER = NULL-SHA

$MESA_TARGET/bin/tls_server -e -c $CIPHER -d -l $LOGLEVEL $C/randoms.dat $C/expired.key $C/expired.cert $C/test_list.cert 4102 

