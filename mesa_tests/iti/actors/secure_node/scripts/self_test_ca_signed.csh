#!/bin/csh

set LOGLEVEL = 4

if ($1 != "") set LOGLEVEL = $1

set C = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.cert.pem
set K = $MESA_TARGET/runtime/certs-ca-signed/test_sys_1.key.pem
set P = $MESA_TARGET/runtime/certs-ca-signed/mesa_list.cert
set R = $MESA_TARGET/runtime/certs-ca-signed/randoms.dat

# Order Placer
$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2101 \
../../../rad/msgs/adt/131/131.102.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2101 \
../../../rad/msgs/adt/131/131.103.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2101 \
../../../rad/msgs/adt/132/132.102.a01.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2101 \
../../../rad/msgs/adt/132/132.103.a01.hl7

echo "Should have BLACK and WISTERIA in Order Placer Database"
psql ordplc < scripts/patient.sql

# Order Filler
$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2201 \
../../../rad/msgs/adt/131/131.102.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2201 \
../../../rad/msgs/adt/131/131.103.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2201 \
../../../rad/msgs/adt/132/132.102.a01.hl7

$MESA_TARGET/bin/send_hl7_secure -C $C -K $K -P $P -R $R localhost 2201 \
../../../rad/msgs/adt/132/132.103.a01.hl7

echo "Should have BLACK and WISTERIA in Order FILLER Database"
psql ordfil < scripts/patient.sql

# C-Echo with MWL server
$MESA_TARGET/bin/cecho_secure -C $C -K $K -P $P -R $R localhost 2251

# PD Supplier
$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3701 \
../../../iti/msgs/adt/113xx/113xx.102.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3701 \
../../../iti/msgs/adt/113xx/113xx.104.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3701 \
../../../iti/msgs/adt/113xx/113xx.106.a04.hl7

echo "Should have CHIP, RALPH and ALICE in the pd_supplier database"
psql pd_supplier < scripts/patient.sql

# PIX Manager
$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3601 \
../../../iti/msgs/adt/10501/10501.102.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3601 \
../../../iti/msgs/adt/10501/10501.104.a04.hl7

$MESA_TARGET/bin/send_hl7_secure -d ihe-iti -C $C -K $K -P $P -R $R localhost 3601 \
../../../iti/msgs/adt/10501/10501.106.a04.hl7

echo "Should have CHIP, RALPH and ALICE in the xref_mgr database"
psql xref_mgr < scripts/patient.sql
