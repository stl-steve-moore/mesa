REM Batch file kills MESA servers for Importer test

REM 2200=DSs/OF, 2300=IM/IA
%MESA_TARGET%\bin\kill_hl7 localhost 2200
%MESA_TARGET%\bin\kill_hl7 localhost 2300

REM 2250=DSS/OF, 2350=IM/IA
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2250
%MESA_TARGET%\bin\open_assoc -s 0 -x 1.2.840.113654.2.30.1 localhost 2350


