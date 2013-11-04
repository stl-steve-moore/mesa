REM Batch file starts MESA servers in secure mode for Image Mgr tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_STORAGE%\imgmgr\hl7\*.hl7

del/Q %MESA_TARGET\%logs\of_hl7ps.log
del/Q %MESA_TARGET\%logs\im_hl7ps.log
del/Q %MESA_TARGET\%logs\imgmgr.log
del/Q %MESA_TARGET\%logs\syslog_server.log

set C=%MESA_TARGET%\runtime\certificates\test_sys_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\test_sys_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\mesa_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat

start %MESA_TARGET%\bin\hl7_rcvr        -l %LEVEL% -M OF -z ordfil -a 2200

start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LEVEL% -M IM -z imgmgr -C %C% -K %K% -P %P% -R %R% 2300

set C=%MESA_TARGET%\runtime\certificates\mesa_1.cert.pem
set K=%MESA_TARGET%\runtime\certificates\mesa_1.key.pem
set P=%MESA_TARGET%\runtime\certificates\test_list.cert
set R=%MESA_TARGET%\runtime\certificates\randoms.dat
start %MESA_TARGET%\bin\of_dcmps_secure -l %LEVEL% -C %C% -K %K% -P %P% -R %R% 2250

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_test.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\wkstation\ds_dcm_gsps.cfg

start %MESA_TARGET%\bin\mod_dcmps_secure -l %LEVEL% -C %C% -K %K% -P %P% -R %R% 2400

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

