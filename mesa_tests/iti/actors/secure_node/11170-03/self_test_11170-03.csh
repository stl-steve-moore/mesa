#!/bin/csh

# Self Test: PIX Query

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

set LOGFILE = $MESA_TARGET/logs/send_hl7_secure.log
if (-e $LOGFILE) rm $LOGFILE

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA

# PD Supplier
$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -l $LOGLEVEL -C $C -K $K -P $P -R $R -Z $Z localhost 3701 \
	../../msgs/pdq/11311/11311.102.q22.hl7

cat $LOGFILE
