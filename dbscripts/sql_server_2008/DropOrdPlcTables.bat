ECHO OFF
REM Arguments: <database name> <login> <password> <password>
ECHO ON
REM Drop Order Placer Tables


sqlcmd -E -d %1 -S %4 < sqlfiles\droppatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropplacerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropfillerorder.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropordr.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql


