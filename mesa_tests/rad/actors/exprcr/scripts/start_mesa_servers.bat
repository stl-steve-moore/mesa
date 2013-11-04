REM Batch file starts MESA Servers for Export Manager tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\expmgr\ds_dcm.cfg
start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\exprcr\ds_dcm.cfg
