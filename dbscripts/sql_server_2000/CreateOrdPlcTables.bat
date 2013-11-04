REM Create Order Placer Tables
REM Arguments: <db name> <login> <password> <server>


isql -S %4 -E -U%2 -P%3 -d %1 < createpatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createplacerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createfillerorder.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createordr.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createidentifiers.sql

isql -S %4 -E -U%2 -P%3 -d %1 < load_id_op.sql

