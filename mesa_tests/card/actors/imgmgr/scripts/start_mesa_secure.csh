#!/bin/csh

set LOGLEVEL = 1

if ($1 != "") set LOGLEVEL = $1

rm -f $MESA_STORAGE/ordfil/*hl7
rm -f $MESA_STORAGE/imgmgr/hl7/*hl7

if (-e $MESA_TARGET/logs/of_hl7ps.log) rm -f $MESA_TARGET/logs/of_hl7ps.log
if (-e $MESA_TARGET/logs/im_hl7ps.log) rm -f $MESA_TARGET/logs/im_hl7ps.log
if (-e $MESA_TARGET/logs/imgmgr.log) rm -f $MESA_TARGET/logs/imgmgr.log
if (-e $MESA_TARGET/logs/syslog_server.log) rm -f $MESA_TARGET/logs/syslog_server.log

# This is for an Image Manager running as a parallel to a system under test
set C = $MESA_TARGET/runtime/certificates/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certificates/mesa_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat

$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M IM -z imgmgr -C $C -K $K -P $P -R $R 2300 &

$MESA_TARGET/bin/hl7_rcvr        -l $LOGLEVEL -M OF -z ordfil -a 2200 &

set C = $MESA_TARGET/runtime/certificates/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certificates/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certificates/test_list.cert
set R = $MESA_TARGET/runtime/certificates/randoms.dat
$MESA_TARGET/bin/of_dcmps_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R 2250 &

$MESA_TARGET/bin/ds_dcm_secure $MESA_TARGET/runtime/imgmgr/ds_dcm_secure_test.cfg &

$MESA_TARGET/bin/ds_dcm $MESA_TARGET/runtime/wkstation/ds_dcm_gsps.cfg &

$MESA_TARGET/bin/mod_dcmps_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R 2400 &

$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

