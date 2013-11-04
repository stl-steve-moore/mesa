echo Modify into BAT file.


REM Order Filler
%MESA_TARGET%\bin\kill_hl7 localhost %MESA_OF_HL7_PORT%

REM Image Manager
%MESA_TARGET%\bin\kill_hl7 localhost %MESA_IMGMGR_HL7_PORT%

REM Order Filler
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost %MESA_OF_DICOM_PORT%

REM Image Manager
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost %MESA_IMGMGR_DICOM_PT%

REM Workstation
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost %MESA_WKSTATION_PORT%

REM Modality
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost %MESA_MODALITY_PORT%

REM Post Processing Manager
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost %MESA_PPM_PORT%

