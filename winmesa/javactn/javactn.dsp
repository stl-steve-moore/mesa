# Microsoft Developer Studio Project File - Name="javactn" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=javactn - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "javactn.mak".
!MESSAGE 
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

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "javactn - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386
# ADD LINK32 mesa_lib.lib wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386

!ELSEIF  "$(CFG)" == "javactn - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "D:\jdk1.3\include" /I "D:\jdk1.3\include\win32" /I "..\..\external\ctn\include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "JAVACTN_EXPORTS" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "javactn - Win32 Release"
# Name "javactn - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\cmd_valid.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\condition\condition.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\thread\ctnthread.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcm.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcm1.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcmcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcmdict.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcmsupport.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\ddr\ddr.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulconstruct.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulfsm.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulparse.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulpresent.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulprotocol.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\dump.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\find.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\get.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\javactn.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\lst\lst.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\lst\lstcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\messages.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\move.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\msgcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\naction.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\ncreate.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\ndelete.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\neventreport.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\nget.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\nset.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\private.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\ref_item.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\send.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\srv1.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\srv2.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\srvcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\storage.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\thread\thrcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\uid\uid.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\uid\uidcond.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\utility\utility.c
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\verify.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=..\..\external\ctn\facilities\condition\condition.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\thread\ctnthread.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dcmprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dicom\dicom.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\ddr\dicom_ddr.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_DDR_DIRInterface.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_DICOMWrapper.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_InfoObj_Image.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_InfoObj_Waveform.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\dicom_messages.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_Misc_Timer.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_Module_ImagePixelModule.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\javactn\jni_src\DICOM_Module_WaveformModule.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\objects\dicom_objects.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dicom\dicom_platform.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\dicom_services.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\uid\dicom_uids.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulfsm.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulprotocol.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\dulprotocol\dulstructures.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\lst\lst.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\lst\lstprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\messages\msgprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\services\private.h
# End Source File
# Begin Source File

SOURCE=..\..\external\ctn\facilities\utility\utility.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
