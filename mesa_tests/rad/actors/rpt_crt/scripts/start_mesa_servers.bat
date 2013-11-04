REM Batch file starts MESA Servers for Report Creator tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordfil
del/Q %MESA_STORAGE%\imgmgr

del/Q %MESA_TARGET%\logs\imgmgr.log
del/Q %MESA_TARGET%\logs\im_hl7ps.log
del/Q %MESA_TARGET%\logs\of_dcmps.log
del/Q %MESA_TARGET%\logs\of_hl7ps.log
del/Q %MESA_TARGET%\logs\op_hl7ps.log
del/Q %MESA_TARGET%\logs\pp_dcmps.log
del/Q %MESA_TARGET%\logs\rm_hl7ps.log
del/Q %MESA_TARGET%\logs\rpt_manager.log
del/Q %MESA_TARGET%\logs\rpt_repos.log
del/Q %MESA_TARGET%\logs\send_hl7.log


start %MESA_TARGET%\bin\hl7_rcvr -M OF -l %LEVEL% -a -z ordfil 2200
start %MESA_TARGET%\bin\hl7_rcvr -M IM -l %LEVEL% -a -z imgmgr 2300
start %MESA_TARGET%\bin\hl7_rcvr -M RM -l %LEVEL% -a -z rpt_manager 2750

start %MESA_TARGET%\bin\of_dcmps 2250

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\rpt_manager\ds_dcm.cfg
start %MESA_TARGET%\bin\pp_dcmps -n rpt_manager -l %LEVEL% 2450
