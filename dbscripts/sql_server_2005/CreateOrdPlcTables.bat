ECHO OFF
REM Arguments: <db name> <login> <password> <server>
ECHO ON
REM Create Order Placer Tables

osql -E -d %1 -S %4 < sqlfiles\createpatient.sql

osql -E -d %1 -S %4 < sqlfiles\createvisit.sql

osql -E -d %1 -S %4 < sqlfiles\createplacerorder.sql

osql -E -d %1 -S %4 < sqlfiles\createfillerorder.sql

osql -E -d %1 -S %4 < sqlfiles\createordr.sql

osql -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

osql -E -d %1 -S %4 < sqlfiles\load_id_op.sql

