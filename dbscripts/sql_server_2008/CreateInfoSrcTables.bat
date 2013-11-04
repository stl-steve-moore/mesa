ECHO OFF
REM Arguments: <database name> <login> <password> <server>
ECHO ON
REM Create Information Source tables

sqlcmd -E -d %1 -S %4  < sqlfiles\createinfosrctables.sql

