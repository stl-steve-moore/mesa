REM This script drops Image Manager tables.
REM Arguments: <database name> <login> <password> <server>

isql -S %4 -E -U%2 -P%3 -d %1 < droppsview.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropsopinsview.sql

isql -S %4 -E -U%2 -P%3 -d %1 < droppatient.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropvisit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropstudy.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropseries.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropsopins.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropdicomapp.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropstoragecommit.sql

isql -S %4 -E -U%2 -P%3 -d %1 < dropppwf.sql

