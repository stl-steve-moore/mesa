REM Stops MESA servers in Report Reader tests

REM Report Repository: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2800

REM Image Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

