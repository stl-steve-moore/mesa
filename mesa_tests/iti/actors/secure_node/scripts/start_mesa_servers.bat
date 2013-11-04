REM Batch file starts MESA servers for PMI tests

set LOGLEVEL=4

if NOT "%1" == "" set LOGLEVEL=%1

echo LOGLEVEL: %LOGLEVEL%

REM start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% 4000

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% -r 5424 -x 5426 4001

start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% -r 5424 -x TCP  4002

REM start %MESA_TARGET%\bin\syslog_server -l %LOGLEVEL% -r 5424 -x 54254003
