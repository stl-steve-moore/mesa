# Microsoft Developer Studio Generated NMAKE File, Based on mesa_extract_nm_frames.dsp
!IF "$(CFG)" == ""
CFG=mesa_extract_nm_frames - Win32 Debug
!MESSAGE No configuration specified. Defaulting to mesa_extract_nm_frames - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "mesa_extract_nm_frames - Win32 Release" && "$(CFG)" != "mesa_extract_nm_frames - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesa_extract_nm_frames.mak" CFG="mesa_extract_nm_frames - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mesa_extract_nm_frames - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "mesa_extract_nm_frames - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "mesa_extract_nm_frames - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\mesa_extract_nm_frames.exe"


CLEAN :
	-@erase "$(INTDIR)\mesa_extract_nm_frames.obj"
	-@erase "$(INTDIR)\LNMFrame.obj"
	-@erase "$(INTDIR)\LNMFrameGated.obj"
	-@erase "$(INTDIR)\LNMFrameTomo.obj"
	-@erase "$(INTDIR)\LNMFrameGatedTomo.obj"
	-@erase "$(INTDIR)\LNMFrameReconTomo.obj"
	-@erase "$(INTDIR)\LNMFrameWholeBody.obj"
	-@erase "$(INTDIR)\LNMFrameStatic.obj"
	-@erase "$(INTDIR)\LNMFrameDynamic.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\mesa_extract_nm_frames.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\mesa_extract_nm_frames.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_extract_nm_frames.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\mesa_extract_nm_frames.pdb" /machine:I386 /out:"$(OUTDIR)\mesa_extract_nm_frames.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\mesa_extract_nm_frames.obj" \
	"$(INTDIR)\LNMFrame.obj" \
	"$(INTDIR)\LNMFrameGated.obj" \
	"$(INTDIR)\LNMFrameTomo.obj" \
	"$(INTDIR)\LNMFrameGatedTomo.obj" \
	"$(INTDIR)\LNMFrameReconTomo.obj" \
	"$(INTDIR)\LNMFrameWholeBody.obj" \
	"$(INTDIR)\LNMFrameStatic.obj" \
	"$(INTDIR)\LNMFrameDynamic.obj"
"$(OUTDIR)\mesa_extract_nm_frames.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mesa_extract_nm_frames - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\mesa_extract_nm_frames.exe"


CLEAN :
	-@erase "$(INTDIR)\mesa_extract_nm_frames.obj"
	-@erase "$(INTDIR)\LNMFrame.obj"
	-@erase "$(INTDIR)\LNMFrameGated.obj"
	-@erase "$(INTDIR)\LNMFrameTomo.obj"
	-@erase "$(INTDIR)\LNMFrameGatedTomo.obj"
	-@erase "$(INTDIR)\LNMFrameReconTomo.obj"
	-@erase "$(INTDIR)\LNMFrameWholeBody.obj"
	-@erase "$(INTDIR)\LNMFrameStatic.obj"
	-@erase "$(INTDIR)\LNMFrameDynamic.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\mesa_extract_nm_frames.exe"
	-@erase "$(OUTDIR)\mesa_extract_nm_frames.ilk"
	-@erase "$(OUTDIR)\mesa_extract_nm_frames.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\mesa_extract_nm_frames.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_extract_nm_frames.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\mesa_extract_nm_frames.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mesa_extract_nm_frames.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\mesa_extract_nm_frames.obj" \
	"$(INTDIR)\LNMFrame.obj" \
	"$(INTDIR)\LNMFrameGated.obj" \
	"$(INTDIR)\LNMFrameTomo.obj" \
	"$(INTDIR)\LNMFrameGatedTomo.obj" \
	"$(INTDIR)\LNMFrameReconTomo.obj" \
	"$(INTDIR)\LNMFrameWholeBody.obj" \
	"$(INTDIR)\LNMFrameStatic.obj" \
	"$(INTDIR)\LNMFrameDynamic.obj"
"$(OUTDIR)\mesa_extract_nm_frames.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("mesa_extract_nm_frames.dep")
!INCLUDE "mesa_extract_nm_frames.dep"
!ELSE 
!MESSAGE Warning: cannot find "mesa_extract_nm_frames.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mesa_extract_nm_frames - Win32 Release" || "$(CFG)" == "mesa_extract_nm_frames - Win32 Debug"
SOURCE=..\..\..\apps\mesa_extract_nm_frames\mesa_extract_nm_frames.cpp

"$(INTDIR)\mesa_extract_nm_frames.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrame.cpp

"$(INTDIR)\LNMFrame.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameGated.cpp

"$(INTDIR)\LNMFrameGated.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameTomo.cpp

"$(INTDIR)\LNMFrameTomo.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameGatedTomo.cpp

"$(INTDIR)\LNMFrameGatedTomo.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameReconTomo.cpp

"$(INTDIR)\LNMFrameReconTomo.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameWholeBody.cpp

"$(INTDIR)\LNMFrameWholeBody.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameStatic.cpp

"$(INTDIR)\LNMFrameStatic.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\apps\mesa_extract_nm_frames\LNMFrameDynamic.cpp

"$(INTDIR)\LNMFrameDynamic.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)
!ENDIF 

