REM Batch file starts MESA servers for secure node tests

set LEVEL=1

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

set C=%MESA_TARGET%\runtime\certificates
set CIPHER=NULL-SHA

%MESA_TARGET%\bin\tls_server -r -v -c %CIPHER% -d -l %LEVEL% %C%\randoms.dat %C%\mesa_1.key.pem %C%\mesa_1.cert.pem %C%\test_list.cert 4100

