REM Create ADT tables
REM Arguments: <database name> <login> <password> <server>

isql -S %4 -E -U%2 -P%3 -d %1 < createpatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createidentifiers.sql

isql -S %4 -E -U%2 -P%3 -d %1 < load_id_adt.sql

