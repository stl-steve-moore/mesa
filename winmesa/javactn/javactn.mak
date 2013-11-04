# Microsoft Developer Studio Generated NMAKE File, Based on javactn.dsp
!IF "$(CFG)" == ""
CFG=javactn - Win32 Debug
!MESSAGE No configuration specified. Defaulting to javactn - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "javactn - Win32 Release" && "$(CFG)" != "javactn - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "javactn.mak" CFG="javactn - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "javactn - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "javactn - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "javactn - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\javactn.dll"


CLEAN :
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\ddr.obj"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\javactn.obj"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\lstcond.obj"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\neventreport.obj"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\ref_item.obj"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(OUTDIR)\javactn.dll"
	-@erase "$(OUTDIR)\javactn.exp"
	-@erase "$(OUTDIR)\javactn.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /Fp"$(INTDIR)\javactn.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\javactn.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\javactn.pdb" /machine:I386 /out:"$(OUTDIR)\javactn.dll" /implib:"$(OUTDIR)\javactn.lib" 
LINK32_OBJS= \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\ddr.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\javactn.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\lstcond.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\neventreport.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\ref_item.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\javactn.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "javactn - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\javactn.dll"


CLEAN :
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\ddr.obj"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\javactn.obj"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\lstcond.obj"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\neventreport.obj"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\ref_item.obj"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(OUTDIR)\javactn.dll"
	-@erase "$(OUTDIR)\javactn.exp"
	-@erase "$(OUTDIR)\javactn.ilk"
	-@erase "$(OUTDIR)\javactn.lib"
	-@erase "$(OUTDIR)\javactn.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /I %JAVA_HOME%/include /I %JAVA_HOME%/include/win32 /I "..\..\..\ctn\include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /Fp"$(INTDIR)\javactn.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\javactn.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\javactn.pdb" /debug /machine:I386 /out:"$(OUTDIR)\javactn.dll" /implib:"$(OUTDIR)\javactn.lib" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\ddr.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\javactn.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\lstcond.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\neventreport.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\ref_item.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj"

"$(OUTDIR)\javactn.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("javactn.dep")
!INCLUDE "javactn.dep"
!ELSE 
!MESSAGE Warning: cannot find "javactn.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "javactn - Win32 Release" || "$(CFG)" == "javactn - Win32 Debug"
SOURCE=..\..\..\ctn\facilities\services\cmd_valid.c

"$(INTDIR)\cmd_valid.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\condition\condition.c

"$(INTDIR)\condition.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\thread\ctnthread.c

"$(INTDIR)\ctnthread.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\objects\dcm.c

"$(INTDIR)\dcm.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\objects\dcm1.c

"$(INTDIR)\dcm1.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\objects\dcmcond.c

"$(INTDIR)\dcmcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\objects\dcmdict.c

"$(INTDIR)\dcmdict.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\objects\dcmsupport.c

"$(INTDIR)\dcmsupport.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\ddr\ddr.c

"$(INTDIR)\ddr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulcond.c

"$(INTDIR)\dulcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulconstruct.c

"$(INTDIR)\dulconstruct.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulfsm.c

"$(INTDIR)\dulfsm.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulparse.c

"$(INTDIR)\dulparse.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulpresent.c

"$(INTDIR)\dulpresent.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\dulprotocol\dulprotocol.c

"$(INTDIR)\dulprotocol.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\dump.c

"$(INTDIR)\dump.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\find.c

"$(INTDIR)\find.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\get.c

"$(INTDIR)\get.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\javactn\jni_src\javactn.c

"$(INTDIR)\javactn.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\lst\lst.c

"$(INTDIR)\lst.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\lst\lstcond.c

"$(INTDIR)\lstcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\messages.c

"$(INTDIR)\messages.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\move.c

"$(INTDIR)\move.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\msgcond.c

"$(INTDIR)\msgcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\naction.c

"$(INTDIR)\naction.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\ncreate.c

"$(INTDIR)\ncreate.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\ndelete.c

"$(INTDIR)\ndelete.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\neventreport.c

"$(INTDIR)\neventreport.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\nget.c

"$(INTDIR)\nget.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\nset.c

"$(INTDIR)\nset.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\private.c

"$(INTDIR)\private.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\ref_item.c

"$(INTDIR)\ref_item.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\send.c

"$(INTDIR)\send.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\srv1.c

"$(INTDIR)\srv1.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\srv2.c

"$(INTDIR)\srv2.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\srvcond.c

"$(INTDIR)\srvcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\storage.c

"$(INTDIR)\storage.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\thread\thrcond.c

"$(INTDIR)\thrcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\uid\uid.c

"$(INTDIR)\uid.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\uid\uidcond.c

"$(INTDIR)\uidcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\utility\utility.c

"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\verify.c

"$(INTDIR)\verify.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

