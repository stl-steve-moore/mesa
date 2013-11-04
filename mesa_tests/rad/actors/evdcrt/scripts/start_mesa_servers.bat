REM Batch file starts MESA Servers for Evidence Creator tests

set LEVEL=1

if NOT "%1" == "" set LEVEL=%1

echo LEVEL: %LEVEL%

REM Image Manager
start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

REM Workstation
start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\wkstation\ds_dcm_gsps.cfg

