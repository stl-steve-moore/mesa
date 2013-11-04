REM Batch file starts MESA Servers for Image Mgr tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_STORAGE%\imgmgr\hl7\*.hl7

del/Q %MESA_TARGET%\logs\of_hl7ps.log
del/Q %MESA_TARGET%\logs\im_hl7ps.log

start %MESA_TARGET%\bin\hl7_rcvr -M IM -a -l %LEVEL% -b %MESA_TARGET%/runtime -d ihe -z imgmgr 2300

start %MESA_TARGET%\bin\hl7_rcvr -M OF -a -l %LEVEL% -b %MESA_TARGET%/runtime -d ihe -a -z ordfil 2200

start %MESA_TARGET%\bin\of_dcmps -l %LEVEL% 2250

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\wkstation\ds_dcm_gsps.cfg

start %MESA_TARGET%\bin\mod_dcmps -l %LEVEL% 2400

start %MESA_TARGET%\bin\pp_dcmps -n imgmgr 2450

