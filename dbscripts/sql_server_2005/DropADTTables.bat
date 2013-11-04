ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Drop ADT Tables

osql -E -S %4 -d %1 < sqlfiles\droppatient.sql

osql -E -S %4 -d %1 < sqlfiles\dropvisit.sql

osql -E -S %4 -d %1 < sqlfiles\dropidentifiers.sql

