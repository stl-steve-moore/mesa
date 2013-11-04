ECHO OFF
REM Arguments: <database name> <login> <password> <server>
REM Create Modality Tables.
ECHO ON

osql -E -d %1 -S %4 < sqlfiles\createpatient.sql

osql -E -d %1 -S %4 < sqlfiles\createvisit.sql

osql -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

osql -E -d %1 -S %4 < sqlfiles\load_id_mod.sql

