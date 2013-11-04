REM Batch file starts MESA Servers for Charge Processor tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\chgp\*.hl7
del/Q %MESA_TARGET%\logs\cp_hl7ps.log
del/Q %MESA_TARGET%\logs\of_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M CP -l %LEVEL% -a -z "" 2150
start %MESA_TARGET%\bin\hl7_rcvr -M OF -l %LEVEL% -a -z "ordfil" 2200

