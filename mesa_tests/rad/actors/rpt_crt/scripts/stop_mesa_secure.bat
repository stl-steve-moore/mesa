REM Stops MESA servers in Report Creator tests

REM Image Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

REM Report Manager: DICOM
set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\mesa_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

%MESA_TARGET%\bin\open_assoc_secure -C %C% -K %K% -P %P% -R %R%  -s 0 -x 1.2.840.113654.2.30.1 localhost 2700

%MESA_TARGET%\bin\syslog_client -c localhost 4000 SHUTDOWN
