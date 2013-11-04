ECHO OFF
REM Arguments: <database name> <login> <password> <server>
REM Create Modality Tables.
ECHO ON

sqlcmd -E -d %1 -S %4 < sqlfiles\createpatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\load_id_mod.sql

