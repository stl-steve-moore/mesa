REM Batch file starts MESA Servers for Modality tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\imgmgr\*.hl7

del/Q %MESA_TARGET%\logs\im_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M IM -l %LEVEL% -a -z imgmgr 2300

REM Start MESA Order Filler for self test

del/Q %MESA_STORAGE%\ordfil\*.hl7

del/Q %MESA_TARGET%\logs\of_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M OF -l %LEVEL% -a -z ordfil 2200

start %MESA_TARGET%\bin\of_dcmps -l %LEVEL% 2250

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg
