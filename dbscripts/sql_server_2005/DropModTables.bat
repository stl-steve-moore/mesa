ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Drop Modality Tables.

osql -E -d %1 -S %4 < sqlfiles\droppatient.sql

osql -E -d %1 -S %4 < sqlfiles\dropvisit.sql

osql -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql


