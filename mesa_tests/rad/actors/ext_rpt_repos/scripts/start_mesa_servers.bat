REM Batch file starts MESA Servers for Ext Rpt Repository tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%lOGLEVEL%

echo LEVEL: %LEVEL%

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\rpt_repos\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\wkstation\ds_dcm_sr.cfg

