# Microsoft Developer Studio Project File - Name="mesa_lib" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=mesa_lib - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "mesa_lib.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mesa_lib.mak" CFG="mesa_lib - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mesa_lib - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "mesa_lib - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "mesa_lib - Win32 Release"

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
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /I "..\..\..\ctn\include" /I "..\..\include" /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /FD /c
# SUBTRACT CPP /YX
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "mesa_lib - Win32 Debug"

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
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /w /W0 /Gm /GX /ZI /Od /I "..\..\..\ctn\include" /I "..\..\include" /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "mesa_lib - Win32 Release"
# Name "mesa_lib - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\build.c
# End Source File
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\cgi-lib.c"
# End Source File
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\cgi-llist.c"
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\cmd_valid.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\condition\condition.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\control.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\thread\ctnthread.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcm.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcm1.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcmcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcmdict.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcmsupport.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\ddr\ddr.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\delete.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\chr\dicom_chr.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulconstruct.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulfsm.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulparse.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulpresent.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulprotocol.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\messages\dump.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\event.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\find.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fis.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fiscond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fisdelete.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fisget.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fisinsert.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\get.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\gq\gq.c
# End Source File
# Begin Source File

SOURCE=..\..\external\hl7\hl7_api.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\iap\iap.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\iap\iapcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\idb\idb.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\idb\idbcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\info_entity\ie.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\info_entity\iecond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\insert.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\lst\lst.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\lst\lstcond.c
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MAcceptor.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MActHumanPerformers.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MActionItem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\mancond.c
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MApplicationEntity.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MAuditMessage.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MAuditMessageFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MCharsetEncoder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MCodeItem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MCommonOrder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MCompositeEval.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MCompositeObjectFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MConfigFile.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MConnector.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MDateTime.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBADT.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBBase.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManager.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManagerJapanese.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManagerStudy.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBIMClient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBInterface.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBModality.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOFClient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderFiller.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderFillerBase.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderFillerJapanese.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderPlacer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderPlacerJapanese.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPDSupplier.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPostProcMgr.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPostProcMgrClient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBSyslogManager.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBXRefMgr.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDDRFile.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMApp.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMAssociation.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMAttribute.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMConfig.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMDir.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MDICOMDomainXlate.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MDICOMElementEval.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMFileMeta.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMProxy.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMProxyTCP.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMReactor.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMWrapper.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDomainObject.cpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\messages\messages.c
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MFileOperations.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MFillerOrder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPPPSObject.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPPPSWorkitem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPSPSObject.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPWorkitem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPWorkitemObject.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Compare.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Dispatcher.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MHL7DomainXlate.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Factory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7MessageControlID.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Msg.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7ProtocolHandlerLLP.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Reactor.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Speaker.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Validator.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MIdentifier.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MInputInfo.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MIssuer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MLogClient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MMESAMisc.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMPPS.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMWL.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMWLObjects.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MNetworkProxy.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MNetworkProxyTCP.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MNonDCMOutput.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MObservationRequest.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MOrder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MOutputInfo.cpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\move.c
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPatient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPatientStudy.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MPDIEval.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfProcApps.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationClass.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationLocation.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationName.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfWorkitem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPlacerOrder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MPPSAssistant.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MQRObjects.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRefGPSPS.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MReqSubsWorkitem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRequestAttribute.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRequestedProcedure.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSchedule.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSeries.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MServerAgent.cpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\messages\msgcond.c
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MSOPHandler.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSOPInstance.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MSOPStorageHandler.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSPS.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemCode.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemContainer.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemImage.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemPName.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemText.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MSREval.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MSREvalTID2000.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRWrapper.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationClass.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationLocation.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationName.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MStorageAgent.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitItem.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitRequest.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitResponse.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MString.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStudy.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogClient.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MSyslogDomainXlate.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSyslogEntry.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogMessage.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MVisit.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MWorkOrder.cpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MWrapperFactory.cpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\naction.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\ncreate.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\ndelete.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\neventreport.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\nget.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\nset.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\print\print.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\print\printcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\private.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\record.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\select.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\send.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\sq\sequences.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\set.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\sq\sqcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\srv1.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\srv2.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\srvcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\storage.c
# End Source File
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\string-lib.c"
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\tbl\tbl_sqlserver.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\tbl\tblcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\thread\thrcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\uid\uid.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\uid\uidcond.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\update.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\utility\utility.c
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\verify.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\cgi-lib.h"
# End Source File
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\cgi-llist.h"
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\condition\condition.h
# End Source File
# Begin Source File

SOURCE=..\..\include\ctn_api.h
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\ctn_api.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\thread\ctnthread.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dcmprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dicom\dicom.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\chr\dicom_chr.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\ddr\dicom_ddr.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\info_entity\dicom_ie.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\messages\dicom_messages.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\objects\dicom_objects.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dicom\dicom_platform.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dicom\dicom_platform_w32.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\print\dicom_print.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\dicom_services.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\sq\dicom_sq.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\uid\dicom_uids.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\dmanprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulfsm.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulprotocol.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\dulprotocol\dulstructures.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fis.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\fis\fis_private.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\gq\gq.h
# End Source File
# Begin Source File

SOURCE=..\..\external\hl7\hl7_api.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\iap\iap.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\idb\idb.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\lst\lst.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\lst\lstprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MAcceptor.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MActHumanPerformers.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MActionItem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\manage\manage.h
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MApplicationEntity.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MAuditMessage.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MAuditMessageFactory.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MCharsetEncoder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MCodeItem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MCommonOrder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MCompositeEval.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MCompositeObjectFactory.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MConfigFile.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MConnector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MDateTime.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBADT.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBBase.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManager.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManagerJapanese.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBImageManagerStudy.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBIMClient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBInterface.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBModality.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOFClient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderFillerBase.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderFillerJapanese.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBOrderPlacerJapanese.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPDSupplier.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPostProcMgr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBPostProcMgrClient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBSyslogManager.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDBXRefMgr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDDRFile.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMApp.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMAssociation.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMAttribute.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMConfig.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMDir.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MDICOMDomainXlate.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MDICOMElementEval.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDICOMFileMeta.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMProxy.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMProxyTCP.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMReactor.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MDICOMWrapper.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MDomainObject.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MESA.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MEval.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MFileOperations.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MFillerOrder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPPPSObject.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPPPSWorkitem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPSPSObject.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPWorkitem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MGPWorkitemObject.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Compare.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Dispatcher.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MHL7DomainXlate.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Factory.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Msg.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7ProtocolHandlerLLP.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Reactor.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\hl7\MHL7Validator.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MIdentifier.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MInputInfo.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MIssuer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MLogClient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MMESAMisc.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMPPS.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMWL.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MMWLObjects.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MNetworkProxy.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MNetworkProxyTCP.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MNonDCMOutput.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MObservationRequest.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MOrder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MOutputInfo.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPatient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPatientStudy.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MPDIEval.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfProcApps.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationClass.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationLocation.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfStationName.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPerfWorkitem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MPlacerOrder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MPPSAssistant.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MQRObjects.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRefGPSPS.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MReqSubsWorkitem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRequestAttribute.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MRequestedProcedure.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSchedule.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSeries.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MServerAgent.hpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\messages\msgprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MSOPHandler.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSOPInstance.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MSOPStorageHandler.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSPS.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemCode.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemContainer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemFactory.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemImage.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemPName.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRContentItemText.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MSREval.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\meval\MSREvalTID2000.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\sr\MSRWrapper.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationClass.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationLocation.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStationName.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\cxxctn\MStorageAgent.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitItem.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitRequest.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStorageCommitResponse.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\common\MString.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MStudy.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogClient.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\translators\MSyslogDomainXlate.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MSyslogEntry.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogFactory.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\syslog\MSyslogMessage.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MVisit.hpp
# End Source File
# Begin Source File

SOURCE=..\..\libsrc\domain\MWorkOrder.hpp
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\services\private.h
# End Source File
# Begin Source File

SOURCE="..\..\external\cgihtml-1.69\string-lib.h"
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\info_entity\tables.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\tbl\tbl.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\tbl\tbl_sqlserver.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\tbl\tblprivate.h
# End Source File
# Begin Source File

SOURCE=..\..\..\ctn\facilities\utility\utility.h
# End Source File
# End Group
# End Target
# End Project
