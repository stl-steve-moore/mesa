REM Batch file starts MESA servers for secure node tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

set C=%MESA_TARGET%\runtime\certificates
set CIPHER=NULL-SHA

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_mesa.cfg
