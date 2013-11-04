ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script drops Order Filler tables


osql -E -d %1 -S %4 < sqlfiles\droppatient.sql

osql -E -d %1 -S %4 < sqlfiles\dropvisit.sql

osql -E -d %1 -S %4 < sqlfiles\dropplacerorder.sql

osql -E -d %1 -S %4 < sqlfiles\dropfillerorder.sql

osql -E -d %1 -S %4 < sqlfiles\dropordr.sql

osql -E -d %1 -S %4 < sqlfiles\dropmwl.sql

osql -E -d %1 -S %4 < sqlfiles\dropactionitem.sql

osql -E -d %1 -S %4 < sqlfiles\dropschedule.sql

osql -E -d %1 -S %4 < sqlfiles\dropidentifiers.sql

osql -E -d %1 -S %4 < sqlfiles\dropppwf.sql


