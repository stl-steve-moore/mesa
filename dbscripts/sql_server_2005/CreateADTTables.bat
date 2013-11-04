ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Create ADT tables

osql -E -S %4 -d %1 < sqlfiles\createpatient.sql

osql -E -S %4 -d %1 < sqlfiles\createvisit.sql

osql -E -S %4 -d %1 < sqlfiles\createidentifiers.sql

osql -E -S %4 -d %1 < sqlfiles\load_id_adt.sql

