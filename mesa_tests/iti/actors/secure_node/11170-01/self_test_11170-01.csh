#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

echo "Self test 11170-01 designed for Patient Identity Source actors"
echo " submitting ADT/registration information with ITI-8"
echo "Database used: xref_mgr"

psql xref_mgr < scripts/clear_patient.sql
echo "PIX Mgr patient table should be empty"
psql xref_mgr < scripts/select_patient.sql

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA


# PIX Manager
$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R -Z $Z localhost 3601 \
 ../../../iti/msgs/adt/10501/10501.102.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R -Z $Z localhost 3601 \
 ../../../iti/msgs/adt/10501/10501.104.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R -Z $Z localhost 3601 \
 ../../../iti/msgs/adt/10501/10501.106.a04.hl7

echo "Should have CARL SIMPSON and two ALAN ALPHA's in the xref_mgr (PIX MGR) database"
psql xref_mgr < scripts/select_patient.sql
