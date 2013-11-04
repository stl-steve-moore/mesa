REM Batch file starts two MESA Servers, Placer and Filler

set LEVEL=0

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc\*.hl7
del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_TARGET%\logs\of_hl7ps.log %MESA_TARGET%\logs\op_hl7ps.log

set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\mesa_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LEVEL% -M OP -C %C% -K %K% -P %P% -R %R% -a -z ordplc 2100

set C=%MESA_TARGET%\runtime\certificates\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\test_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LEVEL% -M OF -C %C% -K %K% -P %P% -R %R% -a -z "" 2200

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

