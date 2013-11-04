@echo off
REM This batch script creates the directory which
REM is named as the first parameter.  If the directory
REM exists, no action is taken.

echo Create directory %1
if not exist %1 mkdir %1