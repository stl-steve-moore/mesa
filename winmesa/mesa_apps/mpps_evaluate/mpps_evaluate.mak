# Microsoft Developer Studio Generated NMAKE File, Based on mpps_evaluate.dsp
!IF "$(CFG)" == ""
CFG=mpps_evaluate - Win32 Debug
!MESSAGE No configuration specified. Defaulting to mpps_evaluate - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "mpps_evaluate - Win32 Release" && "$(CFG)" != "mpps_evaluate - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mpps_evaluate.mak" CFG="mpps_evaluate - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mpps_evaluate - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "mpps_evaluate - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "mpps_evaluate - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\mpps_evaluate.exe"


CLEAN :
	-@erase "$(INTDIR)\MLEvalGroup3.obj"
	-@erase "$(INTDIR)\MLEvalSimple1.obj"
	-@erase "$(INTDIR)\MLEvalUnscheduled2.obj"
	-@erase "$(INTDIR)\MLMPPSEvaluator.obj"
	-@erase "$(INTDIR)\mpps_evaluate.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\mpps_evaluate.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\mpps_evaluate.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mpps_evaluate.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\mpps_evaluate.pdb" /machine:I386 /out:"$(OUTDIR)\mpps_evaluate.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" 
LINK32_OBJS= \
	"$(INTDIR)\MLEvalGroup3.obj" \
	"$(INTDIR)\MLEvalSimple1.obj" \
	"$(INTDIR)\MLEvalUnscheduled2.obj" \
	"$(INTDIR)\MLMPPSEvaluator.obj" \
	"$(INTDIR)\mpps_evaluate.obj"

"$(OUTDIR)\mpps_evaluate.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mpps_evaluate - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\mpps_evaluate.exe"


CLEAN :
	-@erase "$(INTDIR)\MLEvalGroup3.obj"
	-@erase "$(INTDIR)\MLEvalSimple1.obj"
	-@erase "$(INTDIR)\MLEvalUnscheduled2.obj"
	-@erase "$(INTDIR)\MLMPPSEvaluator.obj"
	-@erase "$(INTDIR)\mpps_evaluate.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\mpps_evaluate.exe"
	-@erase "$(OUTDIR)\mpps_evaluate.ilk"
	-@erase "$(OUTDIR)\mpps_evaluate.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\mpps_evaluate.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mpps_evaluate.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\mpps_evaluate.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mpps_evaluate.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" 
LINK32_OBJS= \
	"$(INTDIR)\MLEvalGroup3.obj" \
	"$(INTDIR)\MLEvalSimple1.obj" \
	"$(INTDIR)\MLEvalUnscheduled2.obj" \
	"$(INTDIR)\MLMPPSEvaluator.obj" \
	"$(INTDIR)\mpps_evaluate.obj"

"$(OUTDIR)\mpps_evaluate.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("mpps_evaluate.dep")
!INCLUDE "mpps_evaluate.dep"
!ELSE 
!MESSAGE Warning: cannot find "mpps_evaluate.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mpps_evaluate - Win32 Release" || "$(CFG)" == "mpps_evaluate - Win32 Debug"
SOURCE=..\..\..\apps\mpps_evaluate\MLEvalGroup3.cpp

"$(INTDIR)\MLEvalGroup3.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\mpps_evaluate\MLEvalSimple1.cpp

"$(INTDIR)\MLEvalSimple1.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\mpps_evaluate\MLEvalUnscheduled2.cpp

"$(INTDIR)\MLEvalUnscheduled2.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\mpps_evaluate\MLMPPSEvaluator.cpp

"$(INTDIR)\MLMPPSEvaluator.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\mpps_evaluate\mpps_evaluate.cpp

"$(INTDIR)\mpps_evaluate.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

