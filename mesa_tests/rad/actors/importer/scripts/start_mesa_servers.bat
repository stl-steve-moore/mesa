REM Batch file starts two MESA Servers for Importer tests

set LEVEL=1

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\imgmgr\*.hl7

del/Q %MESA_TARGET%\logs\im_hl7ps.log

REM Image Manager
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M IM -a -z imgmgr 2300

REM start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

REM Start MESA Order Filler

del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_TARGET%\logs\of_hl7ps.log

REM Order Filler
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OF -a -z ordfil 2200

start %MESA_TARGET%\bin\of_dcmps 2250


start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg



