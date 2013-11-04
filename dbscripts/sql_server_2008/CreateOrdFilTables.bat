ECHO off
REM Three arguments: <database name> <login> <password> <server>
ECHO ON
REM This script creates Order Filler tables


sqlcmd -E -d %1 -S %4 < sqlfiles\createpatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createplacerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createfillerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createordr.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createmwl.sql

REM #psql $1 < sqlfiles\createsps.sql

REM #psql $1 < sqlfiles\createrequestedprocedure.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createactionitem.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createschedule.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createppwf.sql

REM #psql $1 < sqlfiles\createcodeitem.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\load_id_of.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\load_codes_of.sql


