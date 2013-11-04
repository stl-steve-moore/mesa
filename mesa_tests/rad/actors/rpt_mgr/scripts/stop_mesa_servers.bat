REM Stops MESA servers in Report Manager tests

%MESA_TARGET%\bin\kill_hl7 localhost 2100
%MESA_TARGET%\bin\kill_hl7 localhost 2200
%MESA_TARGET%\bin\kill_hl7 localhost 2300
%MESA_TARGET%\bin\kill_hl7 localhost 2750
%MESA_TARGET%\bin\kill_hl7 localhost 3300


REM 
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250
REM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350
REM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2450
REM Report Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2700
REM Report Repository: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2800

