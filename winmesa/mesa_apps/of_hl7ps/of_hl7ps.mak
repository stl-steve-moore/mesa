# Microsoft Developer Studio Generated NMAKE File, Based on of_hl7ps.dsp
!IF "$(CFG)" == ""
CFG=of_hl7ps - Win32 Debug
!MESSAGE No configuration specified. Defaulting to of_hl7ps - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "of_hl7ps - Win32 Release" && "$(CFG)" != "of_hl7ps - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "of_hl7ps.mak" CFG="of_hl7ps - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "of_hl7ps - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "of_hl7ps - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "of_hl7ps - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\of_hl7ps.exe"


CLEAN :
	-@erase "$(INTDIR)\MLMessenger.obj"
	-@erase "$(INTDIR)\of_hl7ps.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\of_hl7ps.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /I "..\..\..\..\ACE_wrappers" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\of_hl7ps.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\of_hl7ps.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib ace.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\of_hl7ps.pdb" /machine:I386 /out:"$(OUTDIR)\of_hl7ps.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" /libpath:"..\..\..\..\ACE_wrappers\ace" 
LINK32_OBJS= \
	"$(INTDIR)\MLMessenger.obj" \
	"$(INTDIR)\of_hl7ps.obj"

"$(OUTDIR)\of_hl7ps.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "of_hl7ps - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\of_hl7ps.exe"


CLEAN :
	-@erase "$(INTDIR)\MLMessenger.obj"
	-@erase "$(INTDIR)\of_hl7ps.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\of_hl7ps.exe"
	-@erase "$(OUTDIR)\of_hl7ps.ilk"
	-@erase "$(OUTDIR)\of_hl7ps.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /I "..\..\..\..\ACE_wrappers" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\of_hl7ps.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\of_hl7ps.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib ace.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\of_hl7ps.pdb" /debug /machine:I386 /out:"$(OUTDIR)\of_hl7ps.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" /libpath:"..\..\..\..\ACE_wrappers\ace" 
LINK32_OBJS= \
	"$(INTDIR)\MLMessenger.obj" \
	"$(INTDIR)\of_hl7ps.obj"

"$(OUTDIR)\of_hl7ps.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("of_hl7ps.dep")
!INCLUDE "of_hl7ps.dep"
!ELSE 
!MESSAGE Warning: cannot find "of_hl7ps.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "of_hl7ps - Win32 Release" || "$(CFG)" == "of_hl7ps - Win32 Debug"
SOURCE=..\..\..\apps\of_hl7ps\MLMessenger.cpp

"$(INTDIR)\MLMessenger.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\of_hl7ps\of_hl7ps.cpp

"$(INTDIR)\of_hl7ps.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

