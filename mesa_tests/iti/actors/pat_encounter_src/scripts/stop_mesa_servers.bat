REM stop MESA servers started for Patient Encounter Source tests.

REM MESA Patient Encounter Source
%MESA_TARGET%\bin\kill_hl7 localhost 3900

REM MESA Patient Encounter Consumer
%MESA_TARGET%\bin\kill_hl7 localhost 4100

