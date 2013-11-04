ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Create Cross Reference Manager tables

osql -E -d %1 -S %4 < sqlfiles\createxrefmgrtables.sql

