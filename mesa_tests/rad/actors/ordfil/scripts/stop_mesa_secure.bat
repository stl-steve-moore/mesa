REM Script stops MESA servers running in secure mode
REM (Order Filler tests)

set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\mesa_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

%MESA_TARGET%\bin/kill_hl7_secure -C %C% -K %K% -P %P% -R %R% localhost 2100
%MESA_TARGET%\bin/kill_hl7_secure -C %C% -K %K% -P %P% -R %R% localhost 2300

%MESA_TARGET%\bin/open_assoc_secure -C %C% -K %K% -P %P% -R %R% -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

set C=%MESA_TARGET%\runtime\certificates\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\test_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

%MESA_TARGET%\bin/kill_hl7_secure -C %C% -K %K% -P %P% -R %R% localhost 2200
%MESA_TARGET%\bin\open_assoc_secure -C %C% -K %K% -P %P% -R %R% -s 0 -x 1.2.840.113654.2.30.1 localhost 2250

REM # Audit Record Repository
%MESA_TARGET%\bin\syslog_client -c localhost 4000 SHUTDOWN

