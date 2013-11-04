
@ECHO OFF

set LOGLEVEL=4

set C=%MESA_TARGET%\runtime\certs-ca-signed\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certs-ca-signed\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certs-ca-signed\test_list.cert
set R=%MESA_TARGET%\runtime\certs-ca-signed\randoms.dat
set Z=AES128-SHA

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% -r 5424 -x 5426 4001

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% -r 5424 -x TCP  4002

start %MESA_TARGET%\bin\syslog_server_secure -l %LOGLEVEL% -r 5424 -x 5425 -C %C% -K %K% -P %P% -R %R% -Z %Z% 4003

