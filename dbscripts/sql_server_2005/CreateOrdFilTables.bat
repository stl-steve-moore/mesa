ECHO off
REM Three arguments: <database name> <login> <password> <server>
ECHO ON
REM This script creates Order Filler tables


osql -E -d %1 -S %4 < sqlfiles\createpatient.sql

osql -E -d %1 -S %4 < sqlfiles\createvisit.sql

osql -E -d %1 -S %4 < sqlfiles\createplacerorder.sql

osql -E -d %1 -S %4 < sqlfiles\createfillerorder.sql

osql -E -d %1 -S %4 < sqlfiles\createordr.sql

osql -E -d %1 -S %4 < sqlfiles\createmwl.sql

REM #psql $1 < sqlfiles\createsps.sql

REM #psql $1 < sqlfiles\createrequestedprocedure.sql

osql -E -d %1 -S %4 < sqlfiles\createactionitem.sql

osql -E -d %1 -S %4 < sqlfiles\createschedule.sql

osql -E -d %1 -S %4 < sqlfiles\createppwf.sql

REM #psql $1 < sqlfiles\createcodeitem.sql

osql -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

osql -E -d %1 -S %4 < sqlfiles\load_id_of.sql

osql -E -d %1 -S %4 < sqlfiles\load_codes_of.sql


