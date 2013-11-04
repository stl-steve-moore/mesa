REM Batch file starts MESA Servers for Export Selector

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\expmgr\ds_dcm.cfg
