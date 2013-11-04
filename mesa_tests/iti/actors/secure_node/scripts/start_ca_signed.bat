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

@ECHO OFF
REM Secure Order Filler
del %MESA_TARGET%\logs\of_hl7ps_secure.log
start %MESA_TARGET%\bin\hl7_rcvr_secure -l %LOGLEVEL% -M OF -C %C% -K %K% -P %P% -R %R% -Z %Z% -a -z ordfil 2201
start %MESA_TARGET%\bin\of_dcmps_secure -C %C% -K %K% -P %P% -R %R% -Z %Z% 2251

REM PD Supplier
del %MESA_TARGET%\logs\pds_hl7ps_secure.log
start %MESA_TARGET%\bin\hl7_rcvr_secure -C %C% -K %K% -P %P% -R %R% -Z %Z% -d ihe-iti -M PDS -l %LOGLEVEL% -a -z pd_supplier 3701

REM PIX Manager
del %MESA_TARGET%\logs\pds_hl7ps_secure.log
start %MESA_TARGET%\bin\hl7_rcvr_secure -C %C% -K %K% -P %P% -R %R% -Z %Z% -d ihe-iti -M XR -l %LOGLEVEL% -a -z xref_mgr 3601

