# Microsoft Developer Studio Generated NMAKE File, Based on mesa_xml_eval.dsp
!IF "$(CFG)" == ""
CFG=mesa_xml_eval - Win32 Debug
!MESSAGE No configuration specified. Defaulting to mesa_xml_eval - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "mesa_xml_eval - Win32 Release" && "$(CFG)" != "mesa_xml_eval - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesa_xml_eval.mak" CFG="mesa_xml_eval - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mesa_xml_eval - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "mesa_xml_eval - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "mesa_xml_eval - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\mesa_xml_eval.exe"


CLEAN :
	-@erase "$(INTDIR)\DOMTreeErrorReporter.obj"
	-@erase "$(INTDIR)\mesa_xml_eval.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\mesa_xml_eval.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /I "..\..\..\..\xerces-c-src1_7_0\src" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\mesa_xml_eval.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_xml_eval.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib xerces-c_1.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\mesa_xml_eval.pdb" /machine:I386 /out:"$(OUTDIR)\mesa_xml_eval.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" /libpath:"..\..\..\..\xerces-c-src1_7_0\Build\Win32\VC6\Release" 
LINK32_OBJS= \
	"$(INTDIR)\DOMTreeErrorReporter.obj" \
	"$(INTDIR)\mesa_xml_eval.obj"

"$(OUTDIR)\mesa_xml_eval.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mesa_xml_eval - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\mesa_xml_eval.exe" "$(OUTDIR)\mesa_xml_eval.bsc"


CLEAN :
	-@erase "$(INTDIR)\DOMTreeErrorReporter.obj"
	-@erase "$(INTDIR)\DOMTreeErrorReporter.sbr"
	-@erase "$(INTDIR)\mesa_xml_eval.obj"
	-@erase "$(INTDIR)\mesa_xml_eval.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\mesa_xml_eval.bsc"
	-@erase "$(OUTDIR)\mesa_xml_eval.exe"
	-@erase "$(OUTDIR)\mesa_xml_eval.ilk"
	-@erase "$(OUTDIR)\mesa_xml_eval.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /I "..\..\..\..\xerces-c-src1_7_0\src" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\mesa_xml_eval.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_xml_eval.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DOMTreeErrorReporter.sbr" \
	"$(INTDIR)\mesa_xml_eval.sbr"

"$(OUTDIR)\mesa_xml_eval.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib xerces-c_1D.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\mesa_xml_eval.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mesa_xml_eval.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" /libpath:"..\..\..\..\xerces-c-src1_7_0\Build\Win32\VC6\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\DOMTreeErrorReporter.obj" \
	"$(INTDIR)\mesa_xml_eval.obj"

"$(OUTDIR)\mesa_xml_eval.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("mesa_xml_eval.dep")
!INCLUDE "mesa_xml_eval.dep"
!ELSE 
!MESSAGE Warning: cannot find "mesa_xml_eval.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mesa_xml_eval - Win32 Release" || "$(CFG)" == "mesa_xml_eval - Win32 Debug"
SOURCE=..\..\..\apps\mesa_xml_eval\DOMTreeErrorReporter.cpp

!IF  "$(CFG)" == "mesa_xml_eval - Win32 Release"


"$(INTDIR)\DOMTreeErrorReporter.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "mesa_xml_eval - Win32 Debug"


"$(INTDIR)\DOMTreeErrorReporter.obj"	"$(INTDIR)\DOMTreeErrorReporter.sbr" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ENDIF 

SOURCE=..\..\..\apps\mesa_xml_eval\mesa_xml_eval.cpp

!IF  "$(CFG)" == "mesa_xml_eval - Win32 Release"


"$(INTDIR)\mesa_xml_eval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "mesa_xml_eval - Win32 Debug"


"$(INTDIR)\mesa_xml_eval.obj"	"$(INTDIR)\mesa_xml_eval.sbr" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ENDIF 


!ENDIF 

