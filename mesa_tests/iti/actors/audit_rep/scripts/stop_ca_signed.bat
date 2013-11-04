set LOGLEVEL=4

@ECHO OFF

set C=%MESA_TARGET%\runtime\certs-ca-signed\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certs-ca-signed\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certs-ca-signed\test_list.cert
set R=%MESA_TARGET%\runtime\certs-ca-signed\randoms.dat
set Z=AES128-SHA

%MESA_TARGET%/bin/syslog_client -c -r 5424 -x 5426 localhost 4001 "<SHUTDOWN/>

%MESA_TARGET%/bin/syslog_client -c -r 5424 -x TCP  localhost 4002 "<SHUTDOWN/>

%MESA_TARGET%/bin/syslog_client_secure -c -r 5424 -x 5425 localhost -C %C% -K %K% -P %P% -R %R% -Z %Z% 4003 "<SHUTDOWN/>

