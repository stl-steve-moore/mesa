REM Batch file starts two MESA Servers, Placer and Filler

set LEVEL=0

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc\*.hl7
del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_TARGET%\logs\of_hl7ps.log %MESA_TARGET%\logs\op_hl7ps.log

REM Order Placer
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OP -a -z ordplc 2100

REM Order Filler
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OF -a -z "" 2200

