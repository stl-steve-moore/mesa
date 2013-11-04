#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

set C = $MESA_TARGET/runtime/certs-ca-signed/mesa_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/mesa_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/test_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA

# This is the original BSD protocol, retired
#$MESA_TARGET/bin/syslog_server -l $LOGLEVEL 4000 &

echo "Starting 5424 / 5426 UDP 4001 "
echo $MESA_TARGET/bin/syslog_server -l $LOGLEVEL -r 5424 -x 5426 4001 &

echo "Starting 5424 / TCP  TCP 4002 "
$MESA_TARGET/bin/syslog_server -l $LOGLEVEL -r 5424 -x TCP  4002 &

echo "Starting 5424 / 5425 TLS 4003 "
$MESA_TARGET/bin/syslog_server_secure -l $LOGLEVEL -r 5424 -x 5425 -C $C -K $K -P $P -R $R -Z $Z 4003 &

## Now, all of the secure applications

# Secure Order Filler
rm -r $MESA_STORAGE/ordfil/*hl7
if (-e $MESA_TARGET/logs/of_hl7ps_secure.log) rm -f $MESA_TARGET/logs/of_hl7ps_secure.log
$MESA_TARGET/bin/hl7_rcvr_secure -l $LOGLEVEL -M OF -C $C -K $K -P $P -R $R -Z $Z -a -z ordfil 2201 &
$MESA_TARGET/bin/of_dcmps_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R -Z $Z 2251 &

# PD Supplier
rm -r $MESA_STORAGE/pd_supplier/*hl7
if (-e $MESA_TARGET/logs/pds_hl7ps_secure.log) rm -f $MESA_TARGET/logs/pds_hl7ps_secure.log
$MESA_TARGET/bin/hl7_rcvr_secure -C $C -K $K -P $P -R $R -Z $Z -d ihe-iti -M PDS -l $LOGLEVEL -a -z pd_supplier 3701 &

# PIX Manager
rm -r $MESA_STORAGE/xref/*hl7
if (-e $MESA_TARGET/logs/xr_hl7ps_secure.log) rm -f $MESA_TARGET/logs/pds_hl7ps_secure.log
$MESA_TARGET/bin/hl7_rcvr_secure -C $C -K $K -P $P -R $R -Z $Z -d ihe-iti -M XR -l $LOGLEVEL -a -z xref_mgr 3601 &

