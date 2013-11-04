ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script creates Image Manager tables.


sqlcmd -E -d %1 -S %4 < sqlfiles\createpatient.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createvisit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createstudy.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createseries.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createsopins.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createdicomapp.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createstoragecommit.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createpsview.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createsopinsview.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createppwf.sql

sqlcmd -E -d %1 -S %4 < sqlfiles\createidentifiers.sql
sqlcmd -E -d %1 -S %4 < sqlfiles\load_id_rm.sql

