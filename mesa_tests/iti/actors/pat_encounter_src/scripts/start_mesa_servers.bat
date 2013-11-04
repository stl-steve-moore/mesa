@ECHO OFF

REM This script starts the MESA servers used for testing Patient Demographics Source actors

set LOGLEVEL=0

if NOT "%1" == "" set LOGLEVEL=%1

echo Log Level: %LOGLEVEL%

del/q %MESA_STORAGE%\ordfil\*hl7
del/q %MESA_TARGET%\logs\of_hl7ps.log
del/q %MESA_STORAGE%\ordplc\*hl7
del/q %MESA_TARGET%\logs\op_hl7ps.log

REM MESA Patient Encounter Source
start %MESA_TARGET%\bin\hl7_rcvr -d ihe-iti -M OF -l %LOGLEVEL% -a -z "" 3900
REM MESA Patient Encounter Consumer
start %MESA_TARGET%\bin\hl7_rcvr -d ihe-iti -M OP -l %LOGLEVEL% -a -z "" 4100
