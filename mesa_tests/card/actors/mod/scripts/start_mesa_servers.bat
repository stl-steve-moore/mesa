REM Batch file starts two MESA Servers for Cardiology Stress Workflow tests

set LEVEL=1

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

REM Image Manager
REM del/Q %MESA_STORAGE%\imgmgr\*.hl7
REM del/Q %MESA_TARGET%\logs\im_hl7ps.log
REM start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M IM -a -z imgmgr 2300
start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

REM MESA Order Filler
del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_TARGET%\logs\of_hl7ps.log
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M OF -a -z ordfil 2200
start %MESA_TARGET%\bin\of_dcmps 2250




