#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

echo "Self test 11170-04 designed for Radiology HL7 V2 clients"
echo " submitting ADT/Order/Schedule/Report transactions with RAD-(1,2,3,4,28)"
echo "Database used: ordfil"

psql ordfil  < scripts/clear_patient.sql
psql ordfil  < scripts/clear_placerorder.sql
echo "DSS/OF patient and order tables should be empty"
psql ordfil  < scripts/select_patient.sql
psql ordfil  < scripts/select_placerorder.sql

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat
set Z = AES128-SHA

# Send to Order Filler
$MESA_TARGET/bin/send_hl7_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R -Z $Z localhost 2201 \
	../../../rad/msgs/adt/131/131.102.a04.hl7
$MESA_TARGET/bin/send_hl7_secure -l $LOGLEVEL -C $C -K $K -P $P -R $R -Z $Z localhost 2201 \
	../../../rad/msgs/order/131/131.104.o01.hl7

echo "Should have BLACK^CHARLES in the patient and placer order tables"
psql ordfil  < scripts/select_patient.sql
psql ordfil  < scripts/select_placerorder.sql

