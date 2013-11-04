REM Batch file kills MESA servers for PMI tests

%MESA_TARGET%\bin\kill_hl7 localhost 2200

%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350

