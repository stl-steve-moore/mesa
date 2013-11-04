ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script drops Image Manager tables.

osql -E -d %1 -S %4 < sqlfiles\droppsview.sql

osql -E -d %1 -S %4 < sqlfiles\dropsopinsview.sql

osql -E -d %1 -S %4 < sqlfiles\droppatient.sql

osql -E -d %1 -S %4 < sqlfiles\dropvisit.sql

osql -E -d %1 -S %4 < sqlfiles\dropstudy.sql

osql -E -d %1 -S %4 < sqlfiles\dropseries.sql

osql -E -d %1 -S %4 < sqlfiles\dropsopins.sql

osql -E -d %1 -S %4 < sqlfiles\dropdicomapp.sql

osql -E -d %1 -S %4 < sqlfiles\dropstoragecommit.sql

osql -E -d %1 -S %4 < sqlfiles\dropppwf.sql

