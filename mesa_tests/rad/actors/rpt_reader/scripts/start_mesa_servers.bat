REM Batch file starts MESA Servers for Report Reader tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\rpt_repos\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg
