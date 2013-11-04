REM This script drops Order Filler tables
REM Arguments: <database name> <login> <password> <server>


isql -S %4 -E -U%2 -P%3 -d %1 < droppatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropplacerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropfillerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropordr.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropmwl.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropactionitem.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropschedule.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropidentifiers.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropppwf.sql


