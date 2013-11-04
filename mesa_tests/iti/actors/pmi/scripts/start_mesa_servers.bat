REM Batch file starts MESA servers for PMI tests

set LOGLEVEL=1

if NOT "%1" == "" set LOGLEVEL=%1

echo LOGLEVEL: %LOGLEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% 4000

