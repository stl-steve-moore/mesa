REM Drop Modality Tables.
REM Arguments: <database name> <login> <password> <server>


isql -S %4 -E -U%2 -P%3 -d %1 < droppatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropidentifiers.sql


