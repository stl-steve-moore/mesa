REM Batch file starts two MESA Servers, Placer and Filler

set LOGLEVEL=0

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\ordplc\*.hl7
del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_TARGET%\logs\of_hl7ps.log %MESA_TARGET%\logs\op_hl7ps.log


set C=%MESA_TARGET%\runtime\certificates\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\test_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LEVEL% -M OP -a -z ordplc -C %C% -K %K% -P %P% -R %R% 2100
start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LOGLEVEL% -M OF -a -z ordfil -C %C% -K %K% -P %P% -R %R% 2200

start %MESA_TARGET%\bin\syslog_server -d syslog 4000
