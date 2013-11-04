REM Start MESA servers in secure mode

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%


start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\rpt_repos\ds_dcm_secure_mesa.cfg

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_mesa.cfg

REM MESA Audit Record Repository
start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

