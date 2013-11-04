REM Stops MESA servers in Report Repository tests

REM Report Repository: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2800

REM Workstation: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 3001
