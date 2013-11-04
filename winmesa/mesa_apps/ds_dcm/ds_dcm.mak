# Microsoft Developer Studio Generated NMAKE File, Based on ds_dcm.dsp
!IF "$(CFG)" == ""
CFG=ds_dcm - Win32 Debug
!MESSAGE No configuration specified. Defaulting to ds_dcm - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "ds_dcm - Win32 Release" && "$(CFG)" != "ds_dcm - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ds_dcm.mak" CFG="ds_dcm - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ds_dcm - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "ds_dcm - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ds_dcm - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\ds_dcm.exe"


CLEAN :
	-@erase "$(INTDIR)\ds_dcm.obj"
	-@erase "$(INTDIR)\MLGPPPS.obj"
	-@erase "$(INTDIR)\MLMove.obj"
	-@erase "$(INTDIR)\MLMPPS.obj"
	-@erase "$(INTDIR)\MLQuery.obj"
	-@erase "$(INTDIR)\MLStorage.obj"
	-@erase "$(INTDIR)\MLStorageCommitment.obj"
	-@erase "$(INTDIR)\MLStorageCommitmentSCU.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ds_dcm.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\ds_dcm.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ds_dcm.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\ds_dcm.pdb" /machine:I386 /out:"$(OUTDIR)\ds_dcm.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\ds_dcm.obj" \
	"$(INTDIR)\MLGPPPS.obj" \
	"$(INTDIR)\MLMove.obj" \
	"$(INTDIR)\MLMPPS.obj" \
	"$(INTDIR)\MLQuery.obj" \
	"$(INTDIR)\MLStorage.obj" \
	"$(INTDIR)\MLStorageCommitment.obj" \
	"$(INTDIR)\MLStorageCommitmentSCU.obj" \
	"$(INTDIR)\sscond.obj"

"$(OUTDIR)\ds_dcm.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "ds_dcm - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\ds_dcm.exe"


CLEAN :
	-@erase "$(INTDIR)\ds_dcm.obj"
	-@erase "$(INTDIR)\MLGPPPS.obj"
	-@erase "$(INTDIR)\MLMove.obj"
	-@erase "$(INTDIR)\MLMPPS.obj"
	-@erase "$(INTDIR)\MLQuery.obj"
	-@erase "$(INTDIR)\MLStorage.obj"
	-@erase "$(INTDIR)\MLStorageCommitment.obj"
	-@erase "$(INTDIR)\MLStorageCommitmentSCU.obj"
	-@erase "$(INTDIR)\sscond.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ds_dcm.exe"
	-@erase "$(OUTDIR)\ds_dcm.ilk"
	-@erase "$(OUTDIR)\ds_dcm.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\ds_dcm.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ds_dcm.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\ds_dcm.pdb" /debug /machine:I386 /out:"$(OUTDIR)\ds_dcm.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\ds_dcm.obj" \
	"$(INTDIR)\MLGPPPS.obj" \
	"$(INTDIR)\MLMove.obj" \
	"$(INTDIR)\MLMPPS.obj" \
	"$(INTDIR)\MLQuery.obj" \
	"$(INTDIR)\MLStorage.obj" \
	"$(INTDIR)\MLStorageCommitment.obj" \
	"$(INTDIR)\MLStorageCommitmentSCU.obj" \
	"$(INTDIR)\sscond.obj"

"$(OUTDIR)\ds_dcm.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ds_dcm.dep")
!INCLUDE "ds_dcm.dep"
!ELSE 
!MESSAGE Warning: cannot find "ds_dcm.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ds_dcm - Win32 Release" || "$(CFG)" == "ds_dcm - Win32 Debug"
SOURCE=..\..\..\apps\ds_dcm\ds_dcm.cpp

"$(INTDIR)\ds_dcm.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLGPPPS.cpp

"$(INTDIR)\MLGPPPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLMove.cpp

"$(INTDIR)\MLMove.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLMPPS.cpp

"$(INTDIR)\MLMPPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLQuery.cpp

"$(INTDIR)\MLQuery.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLStorage.cpp

"$(INTDIR)\MLStorage.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\ds_dcm\MLStorageCommitment.cpp

"$(INTDIR)\MLStorageCommitment.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\ds_dcm\MLStorageCommitmentSCU.cpp

"$(INTDIR)\MLStorageCommitmentSCU.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\ds_dcm\sscond.cpp

"$(INTDIR)\sscond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

