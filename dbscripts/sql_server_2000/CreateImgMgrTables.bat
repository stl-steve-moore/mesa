REM This script creates Image Manager tables.
REM Arguments: <database name> <login> <password> <server>


isql -S %4 -E -U%2 -P%3 -d %1 < createpatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createstudy.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createseries.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createsopins.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createdicomapp.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createstoragecommit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createpsview.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createsopinsview.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createppwf.sql

isql -S %4 -E -U%2 -P%3 -d %1 < createidentifiers.sql
isql -S %4 -E -U%2 -P%3 -d %1 < load_id_rm.sql

