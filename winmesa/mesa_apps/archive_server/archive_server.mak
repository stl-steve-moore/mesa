# Microsoft Developer Studio Generated NMAKE File, Based on archive_server.dsp
!IF "$(CFG)" == ""
CFG=archive_server - Win32 Debug
!MESSAGE No configuration specified. Defaulting to archive_server - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "archive_server - Win32 Release" && "$(CFG)" != "archive_server - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "archive_server.mak" CFG="archive_server - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "archive_server - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "archive_server - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "archive_server - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\archive_server.exe"


CLEAN :
	-@erase "$(INTDIR)\archive_server.obj"
	-@erase "$(INTDIR)\association.obj"
	-@erase "$(INTDIR)\cget.obj"
	-@erase "$(INTDIR)\copy.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\parse.obj"
	-@erase "$(INTDIR)\queue.obj"
	-@erase "$(INTDIR)\requests.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\archive_server.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\archive_server.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\archive_server.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\archive_server.pdb" /machine:I386 /out:"$(OUTDIR)\archive_server.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\archive_server.obj" \
	"$(INTDIR)\association.obj" \
	"$(INTDIR)\cget.obj" \
	"$(INTDIR)\copy.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\parse.obj" \
	"$(INTDIR)\queue.obj" \
	"$(INTDIR)\requests.obj" \
	"$(INTDIR)\sscond.obj"

"$(OUTDIR)\archive_server.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "archive_server - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\archive_server.exe"


CLEAN :
	-@erase "$(INTDIR)\archive_server.obj"
	-@erase "$(INTDIR)\association.obj"
	-@erase "$(INTDIR)\cget.obj"
	-@erase "$(INTDIR)\copy.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\parse.obj"
	-@erase "$(INTDIR)\queue.obj"
	-@erase "$(INTDIR)\requests.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\archive_server.exe"
	-@erase "$(OUTDIR)\archive_server.ilk"
	-@erase "$(OUTDIR)\archive_server.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\archive_server.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\archive_server.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\archive_server.pdb" /debug /machine:I386 /out:"$(OUTDIR)\archive_server.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\archive_server.obj" \
	"$(INTDIR)\association.obj" \
	"$(INTDIR)\cget.obj" \
	"$(INTDIR)\copy.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\parse.obj" \
	"$(INTDIR)\queue.obj" \
	"$(INTDIR)\requests.obj" \
	"$(INTDIR)\sscond.obj"

"$(OUTDIR)\archive_server.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("archive_server.dep")
!INCLUDE "archive_server.dep"
!ELSE 
!MESSAGE Warning: cannot find "archive_server.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "archive_server - Win32 Release" || "$(CFG)" == "archive_server - Win32 Debug"
SOURCE=..\..\..\..\ctn\apps\image_archive\archive_server.c

"$(INTDIR)\archive_server.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\association.c

"$(INTDIR)\association.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\cget.c

"$(INTDIR)\cget.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\copy.c

"$(INTDIR)\copy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\find.c

"$(INTDIR)\find.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\move.c

"$(INTDIR)\move.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\naction.c

"$(INTDIR)\naction.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\parse.c

"$(INTDIR)\parse.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\queue.c

"$(INTDIR)\queue.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\requests.c

"$(INTDIR)\requests.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\image_archive\sscond.c

"$(INTDIR)\sscond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

