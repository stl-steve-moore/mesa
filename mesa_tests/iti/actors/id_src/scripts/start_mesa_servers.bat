@ECHO OFF

REM This script starts the MESA servers used for testing Patient ID Source actors

set LOGLEVEL=0

if NOT "%1" == "" set LOGLEVEL=%1

echo Log Level: %LOGLEVEL%

del/q %MESA_STORAGE%\xref\*hl7
del/q %MESA_TARGET%\logs\xr_hl7ps.log

REM XRef Mgr
start %MESA_TARGET%\bin\hl7_rcvr -d ihe-iti -M XR -l %LOGLEVEL% -a -z xref_mgr 3600

