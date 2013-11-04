@ECHO OFF

REM This script stops the MESA servers used for testing XRef Consumer actors

REM XRef Mgr
%MESA_TARGET%\bin\kill_hl7 localhost 3600

