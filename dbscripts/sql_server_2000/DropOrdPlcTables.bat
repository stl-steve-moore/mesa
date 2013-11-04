REM Drop Order Placer Tables
REM Arguments: <database name> <login> <password> <password>


isql -S %4 -E -U%2 -P%3 -d %1 < droppatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropplacerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropfillerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropordr.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropidentifiers.sql


