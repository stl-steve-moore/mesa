ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script drops Image Manager tables.

sqlcmd -E -d %1 -S %4 < sqlfiles\droppsview.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropsopinsview.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\droppatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropstudy.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropseries.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropsopins.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropdicomapp.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropstoragecommit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\dropppwf.sql

