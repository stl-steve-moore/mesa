# Microsoft Developer Studio Generated NMAKE File, Based on hl7_rcvr.dsp
!IF "$(CFG)" == ""
CFG=hl7_rcvr - Win32 Debug
!MESSAGE No configuration specified. Defaulting to hl7_rcvr - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "hl7_rcvr - Win32 Release" && "$(CFG)" != "hl7_rcvr - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "hl7_rcvr.mak" CFG="hl7_rcvr - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "hl7_rcvr - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "hl7_rcvr - Win32 Debug" (based on "Win32 (x86) Console Application")
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

!IF  "$(CFG)" == "hl7_rcvr - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\hl7_rcvr.exe"


CLEAN :
	-@erase "$(INTDIR)\hl7_rcvr.obj"
	-@erase "$(INTDIR)\MLDispatchChargeProcessor.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgr.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgrJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFiller.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFillerJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacer.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacerJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchPDSupplier.obj"
	-@erase "$(INTDIR)\MLDispatchReportMgr.obj"
	-@erase "$(INTDIR)\MLDispatchReportMgrJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchXRefMgr.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\hl7_rcvr.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\hl7_rcvr.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\hl7_rcvr.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\hl7_rcvr.pdb" /machine:I386 /out:"$(OUTDIR)\hl7_rcvr.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\hl7_rcvr.obj" \
	"$(INTDIR)\MLDispatchChargeProcessor.obj" \
	"$(INTDIR)\MLDispatchImgMgr.obj" \
	"$(INTDIR)\MLDispatchImgMgrJapanese.obj" \
	"$(INTDIR)\MLDispatchOrderFiller.obj" \
	"$(INTDIR)\MLDispatchOrderFillerJapanese.obj" \
	"$(INTDIR)\MLDispatchOrderPlacer.obj" \
	"$(INTDIR)\MLDispatchOrderPlacerJapanese.obj" \
	"$(INTDIR)\MLDispatchReportMgr.obj" \
	"$(INTDIR)\MLDispatchReportMgrJapanese.obj" \
	"$(INTDIR)\MLDispatchXRefMgr.obj" \
	"$(INTDIR)\MLDispatchPDSupplier.obj"

"$(OUTDIR)\hl7_rcvr.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "hl7_rcvr - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\hl7_rcvr.exe"


CLEAN :
	-@erase "$(INTDIR)\hl7_rcvr.obj"
	-@erase "$(INTDIR)\MLDispatchChargeProcessor.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgr.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgrJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFiller.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFillerJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacer.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacerJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchPDSupplier.obj"
	-@erase "$(INTDIR)\MLDispatchReportMgr.obj"
	-@erase "$(INTDIR)\MLDispatchReportMgrJapanese.obj"
	-@erase "$(INTDIR)\MLDispatchXRefMgr.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\hl7_rcvr.exe"
	-@erase "$(OUTDIR)\hl7_rcvr.ilk"
	-@erase "$(OUTDIR)\hl7_rcvr.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\include" /I "..\..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\hl7_rcvr.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\hl7_rcvr.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\hl7_rcvr.pdb" /debug /machine:I386 /out:"$(OUTDIR)\hl7_rcvr.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\hl7_rcvr.obj" \
	"$(INTDIR)\MLDispatchChargeProcessor.obj" \
	"$(INTDIR)\MLDispatchImgMgr.obj" \
	"$(INTDIR)\MLDispatchImgMgrJapanese.obj" \
	"$(INTDIR)\MLDispatchOrderFiller.obj" \
	"$(INTDIR)\MLDispatchOrderFillerJapanese.obj" \
	"$(INTDIR)\MLDispatchOrderPlacer.obj" \
	"$(INTDIR)\MLDispatchOrderPlacerJapanese.obj" \
	"$(INTDIR)\MLDispatchReportMgr.obj" \
	"$(INTDIR)\MLDispatchReportMgrJapanese.obj" \
	"$(INTDIR)\MLDispatchXRefMgr.obj" \
	"$(INTDIR)\MLDispatchPDSupplier.obj"

"$(OUTDIR)\hl7_rcvr.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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
!IF EXISTS("hl7_rcvr.dep")
!INCLUDE "hl7_rcvr.dep"
!ELSE 
!MESSAGE Warning: cannot find "hl7_rcvr.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "hl7_rcvr - Win32 Release" || "$(CFG)" == "hl7_rcvr - Win32 Debug"
SOURCE=..\..\..\apps\hl7_rcvr\hl7_rcvr.cpp

"$(INTDIR)\hl7_rcvr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchChargeProcessor.cpp

"$(INTDIR)\MLDispatchChargeProcessor.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchImgMgr.cpp

"$(INTDIR)\MLDispatchImgMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchImgMgrJapanese.cpp

"$(INTDIR)\MLDispatchImgMgrJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchOrderFiller.cpp

"$(INTDIR)\MLDispatchOrderFiller.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchOrderFillerJapanese.cpp

"$(INTDIR)\MLDispatchOrderFillerJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchOrderPlacer.cpp

"$(INTDIR)\MLDispatchOrderPlacer.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchOrderPlacerJapanese.cpp

"$(INTDIR)\MLDispatchOrderPlacerJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchPDSupplier.cpp

"$(INTDIR)\MLDispatchPDSupplier.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchReportMgr.cpp

"$(INTDIR)\MLDispatchReportMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchReportMgrJapanese.cpp

"$(INTDIR)\MLDispatchReportMgrJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\apps\hl7_rcvr\MLDispatchXRefMgr.cpp

"$(INTDIR)\MLDispatchXRefMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

