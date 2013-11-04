REM Batch file starts MESA Servers for Report Creator tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\rpt_manager

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


start %MESA_TARGET%\bin\hl7_rcvr -M RM -l %LEVEL% -a -z rpt_manager 2750
