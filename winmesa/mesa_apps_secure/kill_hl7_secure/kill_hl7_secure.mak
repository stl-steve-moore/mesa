# Microsoft Developer Studio Generated NMAKE File, Based on kill_hl7_secure.dsp
!IF "$(CFG)" == ""
CFG=kill_hl7_secure - Win32 Debug
!MESSAGE No configuration specified. Defaulting to kill_hl7_secure - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "kill_hl7_secure - Win32 Release" && "$(CFG)" != "kill_hl7_secure - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "kill_hl7_secure.mak" CFG="kill_hl7_secure - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "kill_hl7_secure - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "kill_hl7_secure - Win32 Debug" (based on "Win32 (x86) Console Application")
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

!IF  "$(CFG)" == "kill_hl7_secure - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\kill_hl7_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\kill_hl7_secure.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\kill_hl7_secure.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\kill_hl7_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\kill_hl7_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\kill_hl7_secure.pdb" /machine:I386 /out:"$(OUTDIR)\kill_hl7_secure.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" /libpath:"..\..\..\winmesa\mesa_lib_secure\Release" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\kill_hl7_secure.obj"

"$(OUTDIR)\kill_hl7_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "kill_hl7_secure - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\kill_hl7_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\kill_hl7_secure.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\kill_hl7_secure.exe"
	-@erase "$(OUTDIR)\kill_hl7_secure.ilk"
	-@erase "$(OUTDIR)\kill_hl7_secure.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\kill_hl7_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\kill_hl7_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\kill_hl7_secure.pdb" /debug /machine:I386 /out:"$(OUTDIR)\kill_hl7_secure.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" /libpath:"..\..\..\winmesa\mesa_lib_secure\Debug" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\kill_hl7_secure.obj"

"$(OUTDIR)\kill_hl7_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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
!IF EXISTS("kill_hl7_secure.dep")
!INCLUDE "kill_hl7_secure.dep"
!ELSE 
!MESSAGE Warning: cannot find "kill_hl7_secure.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "kill_hl7_secure - Win32 Release" || "$(CFG)" == "kill_hl7_secure - Win32 Debug"
SOURCE=..\..\..\secure_apps\kill_hl7_secure\kill_hl7_secure.cpp

"$(INTDIR)\kill_hl7_secure.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

