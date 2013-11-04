# Microsoft Developer Studio Generated NMAKE File, Based on dcm_w_disp.dsp
!IF "$(CFG)" == ""
CFG=dcm_w_disp - Win32 Debug
!MESSAGE No configuration specified. Defaulting to dcm_w_disp - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "dcm_w_disp - Win32 Release" && "$(CFG)" != "dcm_w_disp - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dcm_w_disp.mak" CFG="dcm_w_disp - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dcm_w_disp - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "dcm_w_disp - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "dcm_w_disp - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\dcm_w_disp.exe"


CLEAN :
	-@erase "$(INTDIR)\dcm_w_disp.obj"
	-@erase "$(INTDIR)\dcm_w_disp.res"
	-@erase "$(INTDIR)\image_utils.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\windows_disp.obj"
	-@erase "$(OUTDIR)\dcm_w_disp.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"$(INTDIR)\dcm_w_disp.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\dcm_w_disp.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dcm_w_disp.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\dcm_w_disp.pdb" /machine:I386 /out:"$(OUTDIR)\dcm_w_disp.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\dcm_w_disp.obj" \
	"$(INTDIR)\image_utils.obj" \
	"$(INTDIR)\windows_disp.obj" \
	"$(INTDIR)\dcm_w_disp.res"

"$(OUTDIR)\dcm_w_disp.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "dcm_w_disp - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\dcm_w_disp.exe"


CLEAN :
	-@erase "$(INTDIR)\dcm_w_disp.obj"
	-@erase "$(INTDIR)\dcm_w_disp.res"
	-@erase "$(INTDIR)\image_utils.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\windows_disp.obj"
	-@erase "$(OUTDIR)\dcm_w_disp.exe"
	-@erase "$(OUTDIR)\dcm_w_disp.ilk"
	-@erase "$(OUTDIR)\dcm_w_disp.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"$(INTDIR)\dcm_w_disp.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\dcm_w_disp.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dcm_w_disp.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\dcm_w_disp.pdb" /debug /machine:I386 /out:"$(OUTDIR)\dcm_w_disp.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\dcm_w_disp.obj" \
	"$(INTDIR)\image_utils.obj" \
	"$(INTDIR)\windows_disp.obj" \
	"$(INTDIR)\dcm_w_disp.res"

"$(OUTDIR)\dcm_w_disp.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("dcm_w_disp.dep")
!INCLUDE "dcm_w_disp.dep"
!ELSE 
!MESSAGE Warning: cannot find "dcm_w_disp.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "dcm_w_disp - Win32 Release" || "$(CFG)" == "dcm_w_disp - Win32 Debug"
SOURCE=..\..\..\..\ctn\apps\dcm_w_disp\dcm_w_disp.c

"$(INTDIR)\dcm_w_disp.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\dcm_w_disp\dcm_w_disp.rc

!IF  "$(CFG)" == "dcm_w_disp - Win32 Release"


"$(INTDIR)\dcm_w_disp.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\dcm_w_disp.res" /i "\projects\mesa-cvs\..\ctn\apps\dcm_w_disp" /d "NDEBUG" $(SOURCE)


!ELSEIF  "$(CFG)" == "dcm_w_disp - Win32 Debug"


"$(INTDIR)\dcm_w_disp.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\dcm_w_disp.res" /i "\projects\mesa-cvs\..\ctn\apps\dcm_w_disp" /d "_DEBUG" $(SOURCE)


!ENDIF 

SOURCE=..\..\..\..\ctn\apps\dcm_w_disp\image_utils.c

"$(INTDIR)\image_utils.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\..\ctn\apps\dcm_w_disp\windows_disp.c

"$(INTDIR)\windows_disp.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

