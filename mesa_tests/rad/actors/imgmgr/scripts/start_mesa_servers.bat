REM Batch file starts MESA Servers for Image Mgr tests
REM This batch file should NOT be executed directly.
REM This file is the Windows analog of the start_mesa_servers.csh

del/Q %MESA_STORAGE%\ordfil\*.hl7
del/Q %MESA_STORAGE%\imgmgr\hl7\*.hl7

del/Q %MESA_TARGET%\logs\of_hl7ps.log
del/Q %MESA_TARGET%\logs\im_hl7ps.log

REM Order Filler
start %MESA_TARGET%\bin\hl7_rcvr -l %LOGLEVEL% -M OF -a -z ordfil %MESA_OF_HL7_PORT%

REM Image Manager
start %MESA_TARGET%\bin\hl7_rcvr -l %LOGLEVEL% -M IM -a -z imgmgr %MESA_IMGMGR_HL7_PORT%

start %MESA_TARGET%\bin\of_dcmps -l %LOGLEVEL% %MESA_OF_DICOM_PORT%

start %MESA_TARGET%\bin\ds_dcm -l %LOGLEVEL% -r %MESA_IMGMGR_DICOM_PT% %MESA_TARGET%\runtime\imgmgr\ds_dcm.cfg

start %MESA_TARGET%\bin\ds_dcm -l %LOGLEVEL% -r %MESA_WKSTATION_PORT% %MESA_TARGET%\runtime\wkstation\ds_dcm_gsps.cfg

start %MESA_TARGET%\bin\mod_dcmps -l %LOGLEVEL% %MESA_MODALITY_PORT%

start %MESA_TARGET%\bin\pp_dcmps -l %LOGLEVEL% -n imgmgr %MESA_PPM_PORT%

