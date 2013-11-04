REM This script creates Order Filler tables
REM Three arguments: <database name> <login> <password> <server>


isql -S %4 -E -U%2 -P%3 -d %1 < createpatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createplacerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createfillerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createordr.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createmwl.sql

REM #psql $1 < createsps.sql

REM #psql $1 < createrequestedprocedure.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createactionitem.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createschedule.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createppwf.sql

REM #psql $1 < createcodeitem.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createidentifiers.sql

isql -S %4 -E -U%2 -P%3 -d %1 < load_id_of.sql

isql -S %4 -E -U%2 -P%3 -d %1 < load_codes_of.sql


