REM Batch file starts MESA Servers for Report Manager tests (secure mode)

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%


start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\rpt_repos\ds_dcm_secure_mesa.cfg

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\rpt_manager\ds_dcm_secure_test.cfg

start %MESA_TARGET%\bin\hl7_rcvr -M OP -l %LEVEL% -a -z "" 3300

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000
