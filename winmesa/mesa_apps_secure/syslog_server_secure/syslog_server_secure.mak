# Microsoft Developer Studio Generated NMAKE File, Based on syslog_server_secure.dsp
!IF "$(CFG)" == ""
CFG=syslog_server_secure - Win32 Debug
!MESSAGE No configuration specified. Defaulting to syslog_server_secure - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "syslog_server_secure - Win32 Release" && "$(CFG)" != "syslog_server_secure - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "syslog_server_secure.mak" CFG="syslog_server_secure - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "syslog_server_secure - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "syslog_server_secure - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "syslog_server_secure - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\syslog_server_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\syslog_server.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\syslog_server_secure.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "RFC5425" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\syslog_server_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\syslog_server_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\syslog_server_secure.pdb" /machine:I386 /out:"$(OUTDIR)\syslog_server_secure.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" /libpath:"..\..\..\winmesa\mesa_lib_secure\Release" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\syslog_server.obj"

"$(OUTDIR)\syslog_server_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "syslog_server_secure - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\syslog_server_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\syslog_server.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\syslog_server_secure.exe"
	-@erase "$(OUTDIR)\syslog_server_secure.ilk"
	-@erase "$(OUTDIR)\syslog_server_secure.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "RFC5425" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\syslog_server_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\syslog_server_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\syslog_server_secure.pdb" /debug /machine:I386 /out:"$(OUTDIR)\syslog_server_secure.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" /libpath:"..\..\..\winmesa\mesa_lib_secure\Debug" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\syslog_server.obj"

"$(OUTDIR)\syslog_server_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("syslog_server_secure.dep")
!INCLUDE "syslog_server_secure.dep"
!ELSE 
!MESSAGE Warning: cannot find "syslog_server_secure.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "syslog_server_secure - Win32 Release" || "$(CFG)" == "syslog_server_secure - Win32 Debug"
SOURCE=..\..\..\apps\syslog_server\syslog_server.cpp

"$(INTDIR)\syslog_server.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

