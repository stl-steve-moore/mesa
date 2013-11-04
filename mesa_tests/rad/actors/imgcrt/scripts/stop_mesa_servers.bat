REM Stops MESA servers in Image Manager tests

REM Order Filler: HL7
%MESA_TARGET%\bin\kill_hl7 localhost 2200

REM Image Manager: HL7
%MESA_TARGET%\bin\kill_hl7 localhost 2300

REM Order Filler: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250

REM Image Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

REM Workstation: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 3001

REM Modality: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2400

REM Post Processing Manager: DICOM
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2450

