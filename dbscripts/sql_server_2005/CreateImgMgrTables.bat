ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script creates Image Manager tables.


osql -E -d %1 -S %4 < sqlfiles\createpatient.sql

osql -E -d %1 -S %4 < sqlfiles\createvisit.sql

osql -E -d %1 -S %4 < sqlfiles\createstudy.sql

osql -E -d %1 -S %4 < sqlfiles\createseries.sql

osql -E -d %1 -S %4 < sqlfiles\createsopins.sql

osql -E -d %1 -S %4 < sqlfiles\createdicomapp.sql

osql -E -d %1 -S %4 < sqlfiles\createstoragecommit.sql

osql -E -d %1 -S %4 < sqlfiles\createpsview.sql

osql -E -d %1 -S %4 < sqlfiles\createsopinsview.sql

osql -E -d %1 -S %4 < sqlfiles\createppwf.sql

osql -E -d %1 -S %4 < sqlfiles\createidentifiers.sql
osql -E -d %1 -S %4 < sqlfiles\load_id_rm.sql

