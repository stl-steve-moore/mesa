ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script drops Order Filler tables


sqlcmd -E -d %1 -S %4 < sqlfiles\droppatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropplacerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropfillerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropordr.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropmwl.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropactionitem.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropschedule.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropppwf.sql


