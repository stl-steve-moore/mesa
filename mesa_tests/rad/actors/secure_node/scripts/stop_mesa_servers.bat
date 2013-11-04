REM Script stops the MESA servers used for Secure Node tests

%MESA_TARGET%\bin\syslog_client -c localhost 4000 SHUTDOWN

set C=%MESA_TARGET%\runtime\certificates

%MESA_TARGET%\bin\tls_connect -s -c NULL-SHA %C%\randoms.dat %C%\test_sys_1.key.pem %C%\test_sys_1.cert.pem %C%\mesa_list.cert localhost 4100

%MESA_TARGET%\bin\tls_connect -s -c NULL-SHA %C%\randoms.dat %C%\test_sys_1.key.pem %C%\test_sys_1.cert.pem %C%\unregistered.cert localhost 4101

%MESA_TARGET%\bin\tls_connect -i EXPIRED -s -c NULL-SHA %C%\randoms.dat %C%\test_sys_1.key.pem %C%\test_sys_1.cert.pem %C%\expired.cert localhost 4102
o

set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\mesa_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat
%MESA_TARGET%\bin\open_assoc_secure -C %C% -K %K% -P %P% -R %R% -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

REM Unregistered certificate
set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\unregistered.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat
%MESA_TARGET%\bin\open_assoc_secure -C %C% -K %K% -P %P% -R %R% -s 0 -x 1.2.840.113654.2.30.1 localhost 2351

REM Expired certificate
set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\expired.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat
%MESA_TARGET%\bin\open_assoc_secure -C %C% -K %K% -P %P% -R %R% -s 0 -x 1.2.840.113654.2.30.1 localhost 2352
