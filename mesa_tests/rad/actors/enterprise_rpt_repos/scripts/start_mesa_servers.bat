REM Batch file starts MESA Server for Enterprise Repository tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc\*.hl7

del/Q %MESA_TARGET%\logs\op_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M OP -l %LEVEL% -b %MESA_TARGET%/runtime -d ihe -a -z "" 3300

