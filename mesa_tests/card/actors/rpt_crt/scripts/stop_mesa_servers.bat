REM Stops MESA servers in Report Creator tests

REM DSS/OF
%MESA_TARGET%\bin\kill_hl7 localhost 2200

REM Image Manager
%MESA_TARGET%\bin\kill_hl7 localhost 2300

REM Report Manager
%MESA_TARGET%\bin\kill_hl7 localhost 2750

REM DSS/OF MWL Server
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250

REM Image Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2450

REM Report Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2700
