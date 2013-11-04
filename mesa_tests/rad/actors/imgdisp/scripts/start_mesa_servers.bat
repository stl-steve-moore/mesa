REM Batch file starts MESA Servers for Image Display tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\imgmgr\hl7\*.hl7

del/Q %MESA_TARGET%\logs\im_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M IM -l %LEVEL% -a -z imgmgr 2300

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg
