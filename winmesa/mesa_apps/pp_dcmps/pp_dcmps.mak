# Microsoft Developer Studio Generated NMAKE File, Based on pp_dcmps.dsp
!IF "$(CFG)" == ""
CFG=pp_dcmps - Win32 Debug
!MESSAGE No configuration specified. Defaulting to pp_dcmps - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "pp_dcmps - Win32 Release" && "$(CFG)" != "pp_dcmps - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "pp_dcmps.mak" CFG="pp_dcmps - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "pp_dcmps - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "pp_dcmps - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "pp_dcmps - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\pp_dcmps.exe"


CLEAN :
	-@erase "$(INTDIR)\MLGPPPS.obj"
	-@erase "$(INTDIR)\MLGPSPS.obj"
	-@erase "$(INTDIR)\MLQuery.obj"
	-@erase "$(INTDIR)\pp_dcmps.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\pp_dcmps.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\pp_dcmps.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\pp_dcmps.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib  kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\pp_dcmps.pdb" /machine:I386 /out:"$(OUTDIR)\pp_dcmps.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\sscond.obj" \
	"$(INTDIR)\MLGPSPS.obj" \
	"$(INTDIR)\MLQuery.obj" \
	"$(INTDIR)\pp_dcmps.obj" \
	"$(INTDIR)\MLGPPPS.obj"

"$(OUTDIR)\pp_dcmps.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "pp_dcmps - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\pp_dcmps.exe"


CLEAN :
	-@erase "$(INTDIR)\MLGPPPS.obj"
	-@erase "$(INTDIR)\MLGPSPS.obj"
	-@erase "$(INTDIR)\MLQuery.obj"
	-@erase "$(INTDIR)\pp_dcmps.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\pp_dcmps.exe"
	-@erase "$(OUTDIR)\pp_dcmps.ilk"
	-@erase "$(OUTDIR)\pp_dcmps.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\pp_dcmps.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ  /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\pp_dcmps.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib  kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\pp_dcmps.pdb" /debug /machine:I386 /out:"$(OUTDIR)\pp_dcmps.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\sscond.obj" \
	"$(INTDIR)\MLGPSPS.obj" \
	"$(INTDIR)\MLQuery.obj" \
	"$(INTDIR)\pp_dcmps.obj" \
	"$(INTDIR)\MLGPPPS.obj"

"$(OUTDIR)\pp_dcmps.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

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


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("pp_dcmps.dep")
!INCLUDE "pp_dcmps.dep"
!ELSE 
!MESSAGE Warning: cannot find "pp_dcmps.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "pp_dcmps - Win32 Release" || "$(CFG)" == "pp_dcmps - Win32 Debug"
SOURCE=..\..\..\apps\pp_dcmps\MLGPPPS.cpp

"$(INTDIR)\MLGPPPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\pp_dcmps\MLGPSPS.cpp

"$(INTDIR)\MLGPSPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\pp_dcmps\MLQuery.cpp

"$(INTDIR)\MLQuery.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\pp_dcmps\pp_dcmps.cpp

"$(INTDIR)\pp_dcmps.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\pp_dcmps\sscond.cpp

"$(INTDIR)\sscond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

