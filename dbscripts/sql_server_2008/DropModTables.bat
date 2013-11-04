ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Drop Modality Tables.

sqlcmd -E -d %1 -S %4 < sqlfiles\droppatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql


