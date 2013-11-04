REM Batch file starts MESA Servers for Report Manager tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc
del/Q %MESA_STORAGE%\ordfil
del/Q %MESA_STORAGE%\imgmgr
del/Q %MESA_STORAGE\chgp\hl7

del/Q %MESA_STORAGE\logs

start %MESA_TARGET%\bin\hl7_rcvr -M OP -l %LEVEL% -a -z ordplc 2100
start %MESA_TARGET%\bin\hl7_rcvr -M OF -l %LEVEL% -a -z ordfil 2200
start %MESA_TARGET%\bin\hl7_rcvr -M IM -l %LEVEL% -a -z imgmgr 2300
start %MESA_TARGET%\bin\hl7_rcvr -M RM -l %LEVEL% -a -z rpt_manager 2750
start %MESA_TARGET%\bin\hl7_rcvr -M OP -l %LEVEL% -a -z "" 3300

start %MESA_TARGET%\bin\of_dcmps 2250

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\pp_dcmps -n rpt_manager -l %LEVEL% 2450

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\rpt_manager\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\rpt_repos\ds_dcm.cfg


