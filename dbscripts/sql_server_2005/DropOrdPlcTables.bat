ECHO OFF
REM Arguments: <database name> <login> <password> <password>
ECHO ON
REM Drop Order Placer Tables


osql -E -d %1 -S %4 < sqlfiles\droppatient.sql

osql -E -d %1 -S %4 < sqlfiles\dropvisit.sql

osql -E -d %1 -S %4 < sqlfiles\dropplacerorder.sql

osql -E -d %1 -S %4 < sqlfiles\dropfillerorder.sql

osql -E -d %1 -S %4 < sqlfiles\dropordr.sql

osql -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql


