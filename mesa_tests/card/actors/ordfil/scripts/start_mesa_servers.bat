REM Batch file starts two MESA Servers for Order Filler tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc\*.hl7

del/Q %MESA_TARGET%\logs\op_hl7ps.log

REM Order Placer
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OP -a -z ordplc 2100

del/Q %MESA_STORAGE%\chgp\*.hl7
del/Q %MESA_TARGET%\logs\cp_hl7ps.log
start %MESA_TARGET%\bin\hl7_rcvr -M CP -l %LEVEL% -a -z "" 2150


del/Q %MESA_STORAGE%\imgmgr\*.hl7

del/Q %MESA_TARGET%\logs\im_hl7ps.log

REM Image Manager
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M IM -a -z imgmgr 2300

REM start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

REM Start MESA Order Filler for self test

del/Q %MESA_STORAGE%\ordfil\*.hl7

del/Q %MESA_TARGET%\logs\of_hl7ps.log

REM Order Filler
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OF -a -z ordfil 2200

start %MESA_TARGET%\bin\of_dcmps 2250


start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\pp_dcmps -n ordfil 2450


