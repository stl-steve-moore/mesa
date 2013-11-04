# Microsoft Developer Studio Generated NMAKE File, Based on mesa_lib_secure.dsp
!IF "$(CFG)" == ""
CFG=mesa_lib_secure - Win32 Debug
!MESSAGE No configuration specified. Defaulting to mesa_lib_secure - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "mesa_lib_secure - Win32 Release" && "$(CFG)" != "mesa_lib_secure - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesa_lib_secure.mak" CFG="mesa_lib_secure - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mesa_lib_secure - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "mesa_lib_secure - Win32 Debug" (based on "Win32 (x86) Static Library")
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

!IF  "$(CFG)" == "mesa_lib_secure - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\mesa_lib_secure.lib"


CLEAN :
	-@erase "$(INTDIR)\app_rand.obj"
	-@erase "$(INTDIR)\MDICOMElementEval.obj"
	-@erase "$(INTDIR)\MDICOMProxyTLS.obj"
	-@erase "$(INTDIR)\MNetworkProxyTLS.obj"
	-@erase "$(INTDIR)\MSyslogClientSecure.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\mesa_lib_secure.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /W3 /EHsc /O2 /I "..\..\..\ctn\include" /I "..\..\include" /I "..\..\..\openssl-0.9.8k\inc32" /D "RFC5425" /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /Fp"$(INTDIR)\mesa_lib_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_lib_secure.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\mesa_lib_secure.lib" 
LIB32_OBJS= \
	"$(INTDIR)\app_rand.obj" \
	"$(INTDIR)\MDICOMProxyTLS.obj" \
	"$(INTDIR)\MNetworkProxyTLS.obj" \
	"$(INTDIR)\MDICOMElementEval.obj" \
	"$(INTDIR)\MSyslogClientSecure.obj"


"$(OUTDIR)\mesa_lib_secure.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mesa_lib_secure - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\mesa_lib_secure.lib"


CLEAN :
	-@erase "$(INTDIR)\app_rand.obj"
	-@erase "$(INTDIR)\MDICOMElementEval.obj"
	-@erase "$(INTDIR)\MDICOMProxyTLS.obj"
	-@erase "$(INTDIR)\MNetworkProxyTLS.obj"
	-@erase "$(INTDIR)\MSyslogClientSecure.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\mesa_lib_secure.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\ctn\include" /I "..\..\include" /I "..\..\..\openssl-0.9.8k\inc32" /D "RFC5425" /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /Fp"$(INTDIR)\mesa_lib_secure.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_lib_secure.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\mesa_lib_secure.lib" 
LIB32_OBJS= \
	"$(INTDIR)\app_rand.obj" \
	"$(INTDIR)\MDICOMProxyTLS.obj" \
	"$(INTDIR)\MNetworkProxyTLS.obj" \
	"$(INTDIR)\MDICOMElementEval.obj" \
	"$(INTDIR)\MSyslogClientSecure.obj"

"$(OUTDIR)\mesa_lib_secure.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
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
!IF EXISTS("mesa_lib_secure.dep")
!INCLUDE "mesa_lib_secure.dep"
!ELSE 
!MESSAGE Warning: cannot find "mesa_lib_secure.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mesa_lib_secure - Win32 Release" || "$(CFG)" == "mesa_lib_secure - Win32 Debug"
SOURCE=..\..\secure_libsrc\mesa\app_rand.cpp

"$(INTDIR)\app_rand.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MDICOMElementEval.cpp

"$(INTDIR)\MDICOMElementEval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\secure_libsrc\mesa\MDICOMProxyTLS.cpp

"$(INTDIR)\MDICOMProxyTLS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\secure_libsrc\mesa\MNetworkProxyTLS.cpp

"$(INTDIR)\MNetworkProxyTLS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\secure_libsrc\mesa\MSyslogClientSecure.cpp

"$(INTDIR)\MSyslogClientSecure.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


!ENDIF 

