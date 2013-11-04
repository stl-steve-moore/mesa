ECHO OFF
REM Arguments: <db name> <login> <password> <server>
ECHO ON
REM Create Order Placer Tables

sqlcmd -E -d %1 -S %4 < sqlfiles\createpatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createplacerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createfillerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createordr.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createidentifiers.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\load_id_op.sql

