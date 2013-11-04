REM Start MESA servers in secure mode

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\rpt_repos\ds_dcm_secure_test.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\wkstation\ds_dcm_sr.cfg

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

