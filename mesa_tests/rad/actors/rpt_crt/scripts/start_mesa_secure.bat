REM Batch file starts MESA Servers for Report Creator tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%


start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\rpt_manager\ds_dcm_secure_mesa.cfg

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000
