# Microsoft Developer Studio Generated NMAKE File, Based on hl7_rcvr_secure.dsp
!IF "$(CFG)" == ""
CFG=hl7_rcvr_secure - Win32 Debug
!MESSAGE No configuration specified. Defaulting to hl7_rcvr_secure - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "hl7_rcvr_secure - Win32 Release" && "$(CFG)" != "hl7_rcvr_secure - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "hl7_rcvr_secure.mak" CFG="hl7_rcvr_secure - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "hl7_rcvr_secure - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "hl7_rcvr_secure - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "hl7_rcvr_secure - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\hl7_rcvr_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\hl7_rcvr_secure.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgr.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFiller.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacer.obj"
	-@erase "$(INTDIR)\MLDispatchPDSupplier.obj"
	-@erase "$(INTDIR)\MLDispatchXRefMgr.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\hl7_rcvr_secure.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\hl7_rcvr_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\hl7_rcvr_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\hl7_rcvr_secure.pdb" /machine:I386 /out:"$(OUTDIR)\hl7_rcvr_secure.exe" /libpath:"..\..\..\winmesa\mesa_lib\Release" /libpath:"..\..\..\winmesa\mesa_lib_secure\Release" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\hl7_rcvr_secure.obj" \
	"$(INTDIR)\MLDispatchImgMgr.obj" \
	"$(INTDIR)\MLDispatchOrderFiller.obj" \
	"$(INTDIR)\MLDispatchPDSupplier.obj" \
	"$(INTDIR)\MLDispatchXRefMgr.obj" \
	"$(INTDIR)\MLDispatchOrderPlacer.obj"

"$(OUTDIR)\hl7_rcvr_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "hl7_rcvr_secure - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\hl7_rcvr_secure.exe"


CLEAN :
	-@erase "$(INTDIR)\hl7_rcvr_secure.obj"
	-@erase "$(INTDIR)\MLDispatchImgMgr.obj"
	-@erase "$(INTDIR)\MLDispatchOrderFiller.obj"
	-@erase "$(INTDIR)\MLDispatchPDSupplier.obj"
	-@erase "$(INTDIR)\MLDispatchXRefMgr.obj"
	-@erase "$(INTDIR)\MLDispatchOrderPlacer.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\hl7_rcvr_secure.exe"
	-@erase "$(OUTDIR)\hl7_rcvr_secure.ilk"
	-@erase "$(OUTDIR)\hl7_rcvr_secure.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\ctn\include" /I "..\..\..\include" /I "..\..\..\..\openssl-0.9.8k\inc32" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\hl7_rcvr_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\hl7_rcvr_secure.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib mesa_lib_secure.lib ssleay32.lib libeay32.lib  wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\hl7_rcvr_secure.pdb" /debug /machine:I386 /out:"$(OUTDIR)\hl7_rcvr_secure.exe" /pdbtype:sept /libpath:"..\..\..\winmesa\mesa_lib\Debug" /libpath:"..\..\..\winmesa\mesa_lib_secure\Debug" /libpath:"..\..\..\..\openssl-0.9.8k\out32dll"  /stack:3072000
LINK32_OBJS= \
	"$(INTDIR)\hl7_rcvr_secure.obj" \
	"$(INTDIR)\MLDispatchImgMgr.obj" \
	"$(INTDIR)\MLDispatchOrderFiller.obj" \
	"$(INTDIR)\MLDispatchPDSupplier.obj" \
	"$(INTDIR)\MLDispatchXRefMgr.obj" \
	"$(INTDIR)\MLDispatchOrderPlacer.obj"

"$(OUTDIR)\hl7_rcvr_secure.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("hl7_rcvr_secure.dep")
!INCLUDE "hl7_rcvr_secure.dep"
!ELSE 
!MESSAGE Warning: cannot find "hl7_rcvr_secure.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "hl7_rcvr_secure - Win32 Release" || "$(CFG)" == "hl7_rcvr_secure - Win32 Debug"
SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\hl7_rcvr_secure.cpp

"$(INTDIR)\hl7_rcvr_secure.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\MLDispatchImgMgr.cpp

"$(INTDIR)\MLDispatchImgMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\MLDispatchOrderFiller.cpp

"$(INTDIR)\MLDispatchOrderFiller.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\MLDispatchPDSupplier.cpp

"$(INTDIR)\MLDispatchPDSupplier.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\MLDispatchXRefMgr.cpp

"$(INTDIR)\MLDispatchXRefMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\..\secure_apps\hl7_rcvr_secure\MLDispatchOrderPlacer.cpp

"$(INTDIR)\MLDispatchOrderPlacer.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

