REM This script drops Cross Reference Manager tables.
REM Arguments: <database name> <login> <password> <server>

isql -S %4 -E -U%2 -P%3 -d %1 < dropxrefmgrtables.sql




