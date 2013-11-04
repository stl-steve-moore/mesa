REM Batch file starts MESA Servers for Media Importer tests

set LEVEL=1

if DEFINED LOGLEVEL set LEVEL=%LOGLEVEL%

echo LEVEL: %LEVEL%

del/Q %MESA_STORAGE%\pmi\*.hl7

del/Q %MESA_TARGET%\logs\pmi_hl7ps.log

REM Portable Media Importer
start %MESA_TARGET%\bin\hl7_rcvr -l %LEVEL% -M PMI -a -z ordfil 2200

start %MESA_TARGET%\bin\ds_dcm %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg



