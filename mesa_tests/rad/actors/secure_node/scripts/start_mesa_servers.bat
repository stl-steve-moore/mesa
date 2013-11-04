REM Batch file starts MESA servers for secure node tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LEVEL% 4000

set C=%MESA_TARGET%\runtime\certificates
set CIPHER=NULL-SHA

start %MESA_TARGET%\bin\tls_server -c %CIPHER% -d -l %LEVEL% %C%\randoms.dat %C%\mesa_1.key.pem %C%\mesa_1.cert.pem %C%\test_list.cert 4100

start %MESA_TARGET%\bin\tls_server -c %CIPHER% -d -l %LEVEL% %C%\randoms.dat %C%\unregistered.key %C%\unregistered.cert %C%\test_list.cert 4101

start %MESA_TARGET%\bin\tls_server -c %CIPHER% -d -l %LEVEL% %C%\randoms.dat %C%\expired.key %C%\expired.cert %C%\test_list.cert 4102


start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_mesa.cfg

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_mesa_unregistered.cfg

start %MESA_TARGET%\bin\ds_dcm_secure %MESA_TARGET%\runtime\imgmgr\ds_dcm_secure_mesa_expired.cfg
