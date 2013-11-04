ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Drop ADT Tables

sqlcmd -E -S %4 -d %1 < sqlfiles\droppatient.sql

sqlcmd -E -S %4 -d %1 < sqlfiles\dropvisit.sql

sqlcmd -E -S %4 -d %1 < sqlfiles\dropidentifiers.sql

