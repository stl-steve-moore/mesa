REM Batch file starts MESA servers for secure node tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

set C=%MESA_TARGET%\runtime\certificates
set CIPHER=NULL-SHA

%MESA_TARGET%\bin\tls_server -u -c %CIPHER% -d -l %LEVEL% %C%\randoms.dat %C%\unregistered.key %C%\unregistered.cert %C%\test_list.cert 4101

