ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Create ADT tables

sqlcmd -E -S %4 -d %1 < sqlfiles\createpatient.sql

sqlcmd -E -S %4 -d %1 < sqlfiles\createvisit.sql

sqlcmd -E -S %4 -d %1 < sqlfiles\createidentifiers.sql

sqlcmd -E -S %4 -d %1 < sqlfiles\load_id_adt.sql

