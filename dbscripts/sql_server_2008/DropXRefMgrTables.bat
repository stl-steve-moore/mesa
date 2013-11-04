ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM This script drops Cross Reference Manager tables.

sqlcmd -E -d %1 -S %4 < sqlfiles\dropxrefmgrtables.sql

