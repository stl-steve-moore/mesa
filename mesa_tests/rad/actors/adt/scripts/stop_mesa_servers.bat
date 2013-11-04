REM Batch file kills MESA servers for ADT test

%MESA_TARGET%\bin\kill_hl7 localhost 2100
%MESA_TARGET%\bin\kill_hl7 localhost 2150
%MESA_TARGET%\bin\kill_hl7 localhost 2200

