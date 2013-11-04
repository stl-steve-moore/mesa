REM Batch file starts MESA Servers for Audit Record Repository tests


del/Q %MESA_TARGET%\logs\syslog_server.log

set LOGLEVEL=1

if NOT "%1" == "" set LOGLEVEL=%1

echo LOGLEVEL: %LOGLEVEL%

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% 4000