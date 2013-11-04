# Microsoft Developer Studio Generated NMAKE File, Based on mesa_lib.dsp
!IF "$(CFG)" == ""
CFG=mesa_lib - Win32 Debug
!MESSAGE No configuration specified. Defaulting to mesa_lib - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "mesa_lib - Win32 Release" && "$(CFG)" != "mesa_lib - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "mesa_lib - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\mesa_lib.lib"


CLEAN :
	-@erase "$(INTDIR)\build.obj"
	-@erase "$(INTDIR)\cgi-lib.obj"
	-@erase "$(INTDIR)\cgi-llist.obj"
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\control.obj"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\ddr.obj"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\dicom_chr.obj"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\event.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\fis.obj"
	-@erase "$(INTDIR)\fiscond.obj"
	-@erase "$(INTDIR)\fisdelete.obj"
	-@erase "$(INTDIR)\fisget.obj"
	-@erase "$(INTDIR)\fisinsert.obj"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\gq.obj"
	-@erase "$(INTDIR)\hl7_api.obj"
	-@erase "$(INTDIR)\iap.obj"
	-@erase "$(INTDIR)\iapcond.obj"
	-@erase "$(INTDIR)\idb.obj"
	-@erase "$(INTDIR)\idbcond.obj"
	-@erase "$(INTDIR)\ie.obj"
	-@erase "$(INTDIR)\iecond.obj"
	-@erase "$(INTDIR)\insert.obj"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\lstcond.obj"
	-@erase "$(INTDIR)\MAcceptor.obj"
	-@erase "$(INTDIR)\MActHumanPerformers.obj"
	-@erase "$(INTDIR)\MActionItem.obj"
	-@erase "$(INTDIR)\mancond.obj"
	-@erase "$(INTDIR)\MApplicationEntity.obj"
	-@erase "$(INTDIR)\MAuditMessage.obj"
	-@erase "$(INTDIR)\MAuditMessageFactory.obj"
	-@erase "$(INTDIR)\MCharsetEncoder.obj"
	-@erase "$(INTDIR)\MCodeItem.obj"
	-@erase "$(INTDIR)\MCommonOrder.obj"
	-@erase "$(INTDIR)\MCompositeEval.obj"
	-@erase "$(INTDIR)\MCompositeObjectFactory.obj"
	-@erase "$(INTDIR)\MConfigFile.obj"
	-@erase "$(INTDIR)\MConnector.obj"
	-@erase "$(INTDIR)\MDateTime.obj"
	-@erase "$(INTDIR)\MDBADT.obj"
	-@erase "$(INTDIR)\MDBBase.obj"
	-@erase "$(INTDIR)\MDBImageManager.obj"
	-@erase "$(INTDIR)\MDBImageManagerJapanese.obj"
	-@erase "$(INTDIR)\MDBImageManagerStudy.obj"
	-@erase "$(INTDIR)\MDBIMClient.obj"
	-@erase "$(INTDIR)\MDBInterface.obj"
	-@erase "$(INTDIR)\MDBModality.obj"
	-@erase "$(INTDIR)\MDBOFClient.obj"
	-@erase "$(INTDIR)\MDBOrderFiller.obj"
	-@erase "$(INTDIR)\MDBOrderFillerBase.obj"
	-@erase "$(INTDIR)\MDBOrderFillerJapanese.obj"
	-@erase "$(INTDIR)\MDBOrderPlacer.obj"
	-@erase "$(INTDIR)\MDBOrderPlacerJapanese.obj"
	-@erase "$(INTDIR)\MDBPDSupplier.obj"
	-@erase "$(INTDIR)\MDBPostProcMgr.obj"
	-@erase "$(INTDIR)\MDBPostProcMgrClient.obj"
	-@erase "$(INTDIR)\MDBSyslogManager.obj"
	-@erase "$(INTDIR)\MDBXRefMgr.obj"
	-@erase "$(INTDIR)\MDDRFile.obj"
	-@erase "$(INTDIR)\MDICOMApp.obj"
	-@erase "$(INTDIR)\MDICOMAssociation.obj"
	-@erase "$(INTDIR)\MDICOMAttribute.obj"
	-@erase "$(INTDIR)\MDICOMConfig.obj"
	-@erase "$(INTDIR)\MDICOMDir.obj"
	-@erase "$(INTDIR)\MDICOMDomainXlate.obj"
	-@erase "$(INTDIR)\MDICOMElementEval.obj"
	-@erase "$(INTDIR)\MDICOMFileMeta.obj"
	-@erase "$(INTDIR)\MDICOMProxy.obj"
	-@erase "$(INTDIR)\MDICOMProxyTCP.obj"
	-@erase "$(INTDIR)\MDICOMReactor.obj"
	-@erase "$(INTDIR)\MDICOMWrapper.obj"
	-@erase "$(INTDIR)\MDomainObject.obj"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\MFileOperations.obj"
	-@erase "$(INTDIR)\MFillerOrder.obj"
	-@erase "$(INTDIR)\MGPPPSObject.obj"
	-@erase "$(INTDIR)\MGPPPSWorkitem.obj"
	-@erase "$(INTDIR)\MGPSPSObject.obj"
	-@erase "$(INTDIR)\MGPWorkitem.obj"
	-@erase "$(INTDIR)\MGPWorkitemObject.obj"
	-@erase "$(INTDIR)\MHL7Compare.obj"
	-@erase "$(INTDIR)\MHL7Dispatcher.obj"
	-@erase "$(INTDIR)\MHL7DomainXlate.obj"
	-@erase "$(INTDIR)\MHL7Factory.obj"
	-@erase "$(INTDIR)\MHL7MessageControlID.obj"
	-@erase "$(INTDIR)\MHL7Msg.obj"
	-@erase "$(INTDIR)\MHL7ProtocolHandlerLLP.obj"
	-@erase "$(INTDIR)\MHL7Reactor.obj"
	-@erase "$(INTDIR)\MHL7Speaker.obj"
	-@erase "$(INTDIR)\MHL7Validator.obj"
	-@erase "$(INTDIR)\MIdentifier.obj"
	-@erase "$(INTDIR)\MInputInfo.obj"
	-@erase "$(INTDIR)\MIssuer.obj"
	-@erase "$(INTDIR)\MLogClient.obj"
	-@erase "$(INTDIR)\MMESAMisc.obj"
	-@erase "$(INTDIR)\MMPPS.obj"
	-@erase "$(INTDIR)\MMWL.obj"
	-@erase "$(INTDIR)\MMWLObjects.obj"
	-@erase "$(INTDIR)\MNetworkProxy.obj"
	-@erase "$(INTDIR)\MNetworkProxyTCP.obj"
	-@erase "$(INTDIR)\MNonDCMOutput.obj"
	-@erase "$(INTDIR)\MObservationRequest.obj"
	-@erase "$(INTDIR)\MOrder.obj"
	-@erase "$(INTDIR)\MOutputInfo.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\MPatient.obj"
	-@erase "$(INTDIR)\MPatientStudy.obj"
	-@erase "$(INTDIR)\MPDIEval.obj"
	-@erase "$(INTDIR)\MPerfProcApps.obj"
	-@erase "$(INTDIR)\MPerfStationClass.obj"
	-@erase "$(INTDIR)\MPerfStationLocation.obj"
	-@erase "$(INTDIR)\MPerfStationName.obj"
	-@erase "$(INTDIR)\MPerfWorkitem.obj"
	-@erase "$(INTDIR)\MPlacerOrder.obj"
	-@erase "$(INTDIR)\MPPSAssistant.obj"
	-@erase "$(INTDIR)\MQRObjects.obj"
	-@erase "$(INTDIR)\MRefGPSPS.obj"
	-@erase "$(INTDIR)\MReqSubsWorkitem.obj"
	-@erase "$(INTDIR)\MRequestAttribute.obj"
	-@erase "$(INTDIR)\MRequestedProcedure.obj"
	-@erase "$(INTDIR)\MSchedule.obj"
	-@erase "$(INTDIR)\MSeries.obj"
	-@erase "$(INTDIR)\MServerAgent.obj"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\MSOPHandler.obj"
	-@erase "$(INTDIR)\MSOPInstance.obj"
	-@erase "$(INTDIR)\MSOPStorageHandler.obj"
	-@erase "$(INTDIR)\MSPS.obj"
	-@erase "$(INTDIR)\MSRContentItem.obj"
	-@erase "$(INTDIR)\MSRContentItemCode.obj"
	-@erase "$(INTDIR)\MSRContentItemContainer.obj"
	-@erase "$(INTDIR)\MSRContentItemFactory.obj"
	-@erase "$(INTDIR)\MSRContentItemImage.obj"
	-@erase "$(INTDIR)\MSRContentItemPName.obj"
	-@erase "$(INTDIR)\MSRContentItemText.obj"
	-@erase "$(INTDIR)\MSREval.obj"
	-@erase "$(INTDIR)\MSREvalTID2000.obj"
	-@erase "$(INTDIR)\MSRWrapper.obj"
	-@erase "$(INTDIR)\MStationClass.obj"
	-@erase "$(INTDIR)\MStationLocation.obj"
	-@erase "$(INTDIR)\MStationName.obj"
	-@erase "$(INTDIR)\MStorageAgent.obj"
	-@erase "$(INTDIR)\MStorageCommitItem.obj"
	-@erase "$(INTDIR)\MStorageCommitRequest.obj"
	-@erase "$(INTDIR)\MStorageCommitResponse.obj"
	-@erase "$(INTDIR)\MString.obj"
	-@erase "$(INTDIR)\MStudy.obj"
	-@erase "$(INTDIR)\MSyslogClient.obj"
	-@erase "$(INTDIR)\MSyslogDomainXlate.obj"
	-@erase "$(INTDIR)\MSyslogEntry.obj"
	-@erase "$(INTDIR)\MSyslogFactory.obj"
	-@erase "$(INTDIR)\MSyslogMessage.obj"
	-@erase "$(INTDIR)\MSyslogMessage5424.obj"
	-@erase "$(INTDIR)\MUWLScheduledStationNameCode.obj"
	-@erase "$(INTDIR)\MUPS.obj"
	-@erase "$(INTDIR)\MUPSObjects.obj"
	-@erase "$(INTDIR)\MVisit.obj"
	-@erase "$(INTDIR)\MWorkOrder.obj"
	-@erase "$(INTDIR)\MWrapperFactory.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\neventreport.obj"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\print.obj"
	-@erase "$(INTDIR)\printcond.obj"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\record.obj"
	-@erase "$(INTDIR)\select.obj"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\sequences.obj"
	-@erase "$(INTDIR)\set.obj"
	-@erase "$(INTDIR)\sqcond.obj"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\string-lib.obj"
	-@erase "$(INTDIR)\tbl_sqlserver.obj"
	-@erase "$(INTDIR)\tblcond.obj"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(OUTDIR)\mesa_lib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MD /W3 /EHsc /O2 /I "..\..\..\ctn\include" /I "..\..\include" /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_lib.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\mesa_lib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\build.obj" \
	"$(INTDIR)\cgi-lib.obj" \
	"$(INTDIR)\cgi-llist.obj" \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\control.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\ddr.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\dicom_chr.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\event.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\fis.obj" \
	"$(INTDIR)\fiscond.obj" \
	"$(INTDIR)\fisdelete.obj" \
	"$(INTDIR)\fisget.obj" \
	"$(INTDIR)\fisinsert.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\gq.obj" \
	"$(INTDIR)\hl7_api.obj" \
	"$(INTDIR)\iap.obj" \
	"$(INTDIR)\iapcond.obj" \
	"$(INTDIR)\idb.obj" \
	"$(INTDIR)\idbcond.obj" \
	"$(INTDIR)\ie.obj" \
	"$(INTDIR)\iecond.obj" \
	"$(INTDIR)\insert.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\lstcond.obj" \
	"$(INTDIR)\MAcceptor.obj" \
	"$(INTDIR)\MActHumanPerformers.obj" \
	"$(INTDIR)\MActionItem.obj" \
	"$(INTDIR)\mancond.obj" \
	"$(INTDIR)\MApplicationEntity.obj" \
	"$(INTDIR)\MAuditMessage.obj" \
	"$(INTDIR)\MAuditMessageFactory.obj" \
	"$(INTDIR)\MCharsetEncoder.obj" \
	"$(INTDIR)\MCodeItem.obj" \
	"$(INTDIR)\MCommonOrder.obj" \
	"$(INTDIR)\MCompositeEval.obj" \
	"$(INTDIR)\MCompositeObjectFactory.obj" \
	"$(INTDIR)\MConfigFile.obj" \
	"$(INTDIR)\MConnector.obj" \
	"$(INTDIR)\MDateTime.obj" \
	"$(INTDIR)\MDBADT.obj" \
	"$(INTDIR)\MDBBase.obj" \
	"$(INTDIR)\MDBImageManager.obj" \
	"$(INTDIR)\MDBImageManagerJapanese.obj" \
	"$(INTDIR)\MDBImageManagerStudy.obj" \
	"$(INTDIR)\MDBIMClient.obj" \
	"$(INTDIR)\MDBInterface.obj" \
	"$(INTDIR)\MDBModality.obj" \
	"$(INTDIR)\MDBOFClient.obj" \
	"$(INTDIR)\MDBOrderFiller.obj" \
	"$(INTDIR)\MDBOrderFillerBase.obj" \
	"$(INTDIR)\MDBOrderFillerJapanese.obj" \
	"$(INTDIR)\MDBOrderPlacer.obj" \
	"$(INTDIR)\MDBOrderPlacerJapanese.obj" \
	"$(INTDIR)\MDBPostProcMgr.obj" \
	"$(INTDIR)\MDBPostProcMgrClient.obj" \
	"$(INTDIR)\MDBSyslogManager.obj" \
	"$(INTDIR)\MDBXRefMgr.obj" \
	"$(INTDIR)\MDDRFile.obj" \
	"$(INTDIR)\MDICOMApp.obj" \
	"$(INTDIR)\MDICOMAssociation.obj" \
	"$(INTDIR)\MDICOMAttribute.obj" \
	"$(INTDIR)\MDICOMConfig.obj" \
	"$(INTDIR)\MDICOMDir.obj" \
	"$(INTDIR)\MDICOMDomainXlate.obj" \
	"$(INTDIR)\MDICOMElementEval.obj" \
	"$(INTDIR)\MDICOMFileMeta.obj" \
	"$(INTDIR)\MDICOMProxy.obj" \
	"$(INTDIR)\MDICOMProxyTCP.obj" \
	"$(INTDIR)\MDICOMReactor.obj" \
	"$(INTDIR)\MDICOMWrapper.obj" \
	"$(INTDIR)\MDomainObject.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\MFileOperations.obj" \
	"$(INTDIR)\MFillerOrder.obj" \
	"$(INTDIR)\MGPPPSObject.obj" \
	"$(INTDIR)\MGPPPSWorkitem.obj" \
	"$(INTDIR)\MGPSPSObject.obj" \
	"$(INTDIR)\MGPWorkitem.obj" \
	"$(INTDIR)\MGPWorkitemObject.obj" \
	"$(INTDIR)\MHL7Compare.obj" \
	"$(INTDIR)\MHL7Dispatcher.obj" \
	"$(INTDIR)\MHL7DomainXlate.obj" \
	"$(INTDIR)\MHL7Factory.obj" \
	"$(INTDIR)\MHL7MessageControlID.obj" \
	"$(INTDIR)\MHL7Msg.obj" \
	"$(INTDIR)\MHL7ProtocolHandlerLLP.obj" \
	"$(INTDIR)\MHL7Reactor.obj" \
	"$(INTDIR)\MHL7Speaker.obj" \
	"$(INTDIR)\MHL7Validator.obj" \
	"$(INTDIR)\MIdentifier.obj" \
	"$(INTDIR)\MInputInfo.obj" \
	"$(INTDIR)\MIssuer.obj" \
	"$(INTDIR)\MLogClient.obj" \
	"$(INTDIR)\MMESAMisc.obj" \
	"$(INTDIR)\MMPPS.obj" \
	"$(INTDIR)\MMWL.obj" \
	"$(INTDIR)\MMWLObjects.obj" \
	"$(INTDIR)\MNetworkProxy.obj" \
	"$(INTDIR)\MNetworkProxyTCP.obj" \
	"$(INTDIR)\MNonDCMOutput.obj" \
	"$(INTDIR)\MObservationRequest.obj" \
	"$(INTDIR)\MOrder.obj" \
	"$(INTDIR)\MOutputInfo.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\MPatient.obj" \
	"$(INTDIR)\MPatientStudy.obj" \
	"$(INTDIR)\MPDIEval.obj" \
	"$(INTDIR)\MPerfProcApps.obj" \
	"$(INTDIR)\MPerfStationClass.obj" \
	"$(INTDIR)\MPerfStationLocation.obj" \
	"$(INTDIR)\MPerfStationName.obj" \
	"$(INTDIR)\MPerfWorkitem.obj" \
	"$(INTDIR)\MPlacerOrder.obj" \
	"$(INTDIR)\MPPSAssistant.obj" \
	"$(INTDIR)\MQRObjects.obj" \
	"$(INTDIR)\MRefGPSPS.obj" \
	"$(INTDIR)\MReqSubsWorkitem.obj" \
	"$(INTDIR)\MRequestAttribute.obj" \
	"$(INTDIR)\MRequestedProcedure.obj" \
	"$(INTDIR)\MSchedule.obj" \
	"$(INTDIR)\MSeries.obj" \
	"$(INTDIR)\MServerAgent.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\MSOPHandler.obj" \
	"$(INTDIR)\MSOPInstance.obj" \
	"$(INTDIR)\MSOPStorageHandler.obj" \
	"$(INTDIR)\MSPS.obj" \
	"$(INTDIR)\MSRContentItem.obj" \
	"$(INTDIR)\MSRContentItemCode.obj" \
	"$(INTDIR)\MSRContentItemContainer.obj" \
	"$(INTDIR)\MSRContentItemFactory.obj" \
	"$(INTDIR)\MSRContentItemImage.obj" \
	"$(INTDIR)\MSRContentItemPName.obj" \
	"$(INTDIR)\MSRContentItemText.obj" \
	"$(INTDIR)\MSREval.obj" \
	"$(INTDIR)\MSREvalTID2000.obj" \
	"$(INTDIR)\MSRWrapper.obj" \
	"$(INTDIR)\MStationClass.obj" \
	"$(INTDIR)\MStationLocation.obj" \
	"$(INTDIR)\MStationName.obj" \
	"$(INTDIR)\MStorageAgent.obj" \
	"$(INTDIR)\MStorageCommitItem.obj" \
	"$(INTDIR)\MStorageCommitRequest.obj" \
	"$(INTDIR)\MStorageCommitResponse.obj" \
	"$(INTDIR)\MString.obj" \
	"$(INTDIR)\MStudy.obj" \
	"$(INTDIR)\MSyslogClient.obj" \
	"$(INTDIR)\MSyslogDomainXlate.obj" \
	"$(INTDIR)\MSyslogEntry.obj" \
	"$(INTDIR)\MSyslogFactory.obj" \
	"$(INTDIR)\MSyslogMessage.obj" \
	"$(INTDIR)\MSyslogMessage5424.obj" \
	"$(INTDIR)\MUWLScheduledStationNameCode.obj" \
	"$(INTDIR)\MUPS.obj" \
	"$(INTDIR)\MUPSObjects.obj" \
	"$(INTDIR)\MVisit.obj" \
	"$(INTDIR)\MWorkOrder.obj" \
	"$(INTDIR)\MWrapperFactory.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\neventreport.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\print.obj" \
	"$(INTDIR)\printcond.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\record.obj" \
	"$(INTDIR)\select.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\sequences.obj" \
	"$(INTDIR)\set.obj" \
	"$(INTDIR)\sqcond.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\string-lib.obj" \
	"$(INTDIR)\tbl_sqlserver.obj" \
	"$(INTDIR)\tblcond.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj" \
	"$(INTDIR)\MDBPDSupplier.obj"

"$(OUTDIR)\mesa_lib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mesa_lib - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\mesa_lib.lib"


CLEAN :
	-@erase "$(INTDIR)\build.obj"
	-@erase "$(INTDIR)\cgi-lib.obj"
	-@erase "$(INTDIR)\cgi-llist.obj"
	-@erase "$(INTDIR)\cmd_valid.obj"
	-@erase "$(INTDIR)\condition.obj"
	-@erase "$(INTDIR)\control.obj"
	-@erase "$(INTDIR)\ctnthread.obj"
	-@erase "$(INTDIR)\dcm.obj"
	-@erase "$(INTDIR)\dcm1.obj"
	-@erase "$(INTDIR)\dcmcond.obj"
	-@erase "$(INTDIR)\dcmdict.obj"
	-@erase "$(INTDIR)\dcmsupport.obj"
	-@erase "$(INTDIR)\ddr.obj"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\dicom_chr.obj"
	-@erase "$(INTDIR)\dulcond.obj"
	-@erase "$(INTDIR)\dulconstruct.obj"
	-@erase "$(INTDIR)\dulfsm.obj"
	-@erase "$(INTDIR)\dulparse.obj"
	-@erase "$(INTDIR)\dulpresent.obj"
	-@erase "$(INTDIR)\dulprotocol.obj"
	-@erase "$(INTDIR)\dump.obj"
	-@erase "$(INTDIR)\event.obj"
	-@erase "$(INTDIR)\find.obj"
	-@erase "$(INTDIR)\fis.obj"
	-@erase "$(INTDIR)\fiscond.obj"
	-@erase "$(INTDIR)\fisdelete.obj"
	-@erase "$(INTDIR)\fisget.obj"
	-@erase "$(INTDIR)\fisinsert.obj"
	-@erase "$(INTDIR)\get.obj"
	-@erase "$(INTDIR)\gq.obj"
	-@erase "$(INTDIR)\hl7_api.obj"
	-@erase "$(INTDIR)\iap.obj"
	-@erase "$(INTDIR)\iapcond.obj"
	-@erase "$(INTDIR)\idb.obj"
	-@erase "$(INTDIR)\idbcond.obj"
	-@erase "$(INTDIR)\ie.obj"
	-@erase "$(INTDIR)\iecond.obj"
	-@erase "$(INTDIR)\insert.obj"
	-@erase "$(INTDIR)\lst.obj"
	-@erase "$(INTDIR)\lstcond.obj"
	-@erase "$(INTDIR)\MAcceptor.obj"
	-@erase "$(INTDIR)\MActHumanPerformers.obj"
	-@erase "$(INTDIR)\MActionItem.obj"
	-@erase "$(INTDIR)\mancond.obj"
	-@erase "$(INTDIR)\MApplicationEntity.obj"
	-@erase "$(INTDIR)\MAuditMessage.obj"
	-@erase "$(INTDIR)\MAuditMessageFactory.obj"
	-@erase "$(INTDIR)\MCharsetEncoder.obj"
	-@erase "$(INTDIR)\MCodeItem.obj"
	-@erase "$(INTDIR)\MCommonOrder.obj"
	-@erase "$(INTDIR)\MCompositeEval.obj"
	-@erase "$(INTDIR)\MCompositeObjectFactory.obj"
	-@erase "$(INTDIR)\MConfigFile.obj"
	-@erase "$(INTDIR)\MConnector.obj"
	-@erase "$(INTDIR)\MDateTime.obj"
	-@erase "$(INTDIR)\MDBADT.obj"
	-@erase "$(INTDIR)\MDBBase.obj"
	-@erase "$(INTDIR)\MDBImageManager.obj"
	-@erase "$(INTDIR)\MDBImageManagerJapanese.obj"
	-@erase "$(INTDIR)\MDBImageManagerStudy.obj"
	-@erase "$(INTDIR)\MDBIMClient.obj"
	-@erase "$(INTDIR)\MDBInterface.obj"
	-@erase "$(INTDIR)\MDBModality.obj"
	-@erase "$(INTDIR)\MDBOFClient.obj"
	-@erase "$(INTDIR)\MDBOrderFiller.obj"
	-@erase "$(INTDIR)\MDBOrderFillerBase.obj"
	-@erase "$(INTDIR)\MDBOrderFillerJapanese.obj"
	-@erase "$(INTDIR)\MDBOrderPlacer.obj"
	-@erase "$(INTDIR)\MDBOrderPlacerJapanese.obj"
	-@erase "$(INTDIR)\MDBPDSupplier.obj"
	-@erase "$(INTDIR)\MDBPostProcMgr.obj"
	-@erase "$(INTDIR)\MDBPostProcMgrClient.obj"
	-@erase "$(INTDIR)\MDBSyslogManager.obj"
	-@erase "$(INTDIR)\MDBXRefMgr.obj"
	-@erase "$(INTDIR)\MDDRFile.obj"
	-@erase "$(INTDIR)\MDICOMApp.obj"
	-@erase "$(INTDIR)\MDICOMAssociation.obj"
	-@erase "$(INTDIR)\MDICOMAttribute.obj"
	-@erase "$(INTDIR)\MDICOMConfig.obj"
	-@erase "$(INTDIR)\MDICOMDir.obj"
	-@erase "$(INTDIR)\MDICOMDomainXlate.obj"
	-@erase "$(INTDIR)\MDICOMElementEval.obj"
	-@erase "$(INTDIR)\MDICOMFileMeta.obj"
	-@erase "$(INTDIR)\MDICOMProxy.obj"
	-@erase "$(INTDIR)\MDICOMProxyTCP.obj"
	-@erase "$(INTDIR)\MDICOMReactor.obj"
	-@erase "$(INTDIR)\MDICOMWrapper.obj"
	-@erase "$(INTDIR)\MDomainObject.obj"
	-@erase "$(INTDIR)\messages.obj"
	-@erase "$(INTDIR)\MFileOperations.obj"
	-@erase "$(INTDIR)\MFillerOrder.obj"
	-@erase "$(INTDIR)\MGPPPSObject.obj"
	-@erase "$(INTDIR)\MGPPPSWorkitem.obj"
	-@erase "$(INTDIR)\MGPSPSObject.obj"
	-@erase "$(INTDIR)\MGPWorkitem.obj"
	-@erase "$(INTDIR)\MGPWorkitemObject.obj"
	-@erase "$(INTDIR)\MHL7Compare.obj"
	-@erase "$(INTDIR)\MHL7Dispatcher.obj"
	-@erase "$(INTDIR)\MHL7DomainXlate.obj"
	-@erase "$(INTDIR)\MHL7Factory.obj"
	-@erase "$(INTDIR)\MHL7MessageControlID.obj"
	-@erase "$(INTDIR)\MHL7Msg.obj"
	-@erase "$(INTDIR)\MHL7ProtocolHandlerLLP.obj"
	-@erase "$(INTDIR)\MHL7Reactor.obj"
	-@erase "$(INTDIR)\MHL7Speaker.obj"
	-@erase "$(INTDIR)\MHL7Validator.obj"
	-@erase "$(INTDIR)\MIdentifier.obj"
	-@erase "$(INTDIR)\MInputInfo.obj"
	-@erase "$(INTDIR)\MIssuer.obj"
	-@erase "$(INTDIR)\MLogClient.obj"
	-@erase "$(INTDIR)\MMESAMisc.obj"
	-@erase "$(INTDIR)\MMPPS.obj"
	-@erase "$(INTDIR)\MMWL.obj"
	-@erase "$(INTDIR)\MMWLObjects.obj"
	-@erase "$(INTDIR)\MNetworkProxy.obj"
	-@erase "$(INTDIR)\MNetworkProxyTCP.obj"
	-@erase "$(INTDIR)\MNonDCMOutput.obj"
	-@erase "$(INTDIR)\MObservationRequest.obj"
	-@erase "$(INTDIR)\MOrder.obj"
	-@erase "$(INTDIR)\MOutputInfo.obj"
	-@erase "$(INTDIR)\move.obj"
	-@erase "$(INTDIR)\MPatient.obj"
	-@erase "$(INTDIR)\MPatientStudy.obj"
	-@erase "$(INTDIR)\MPDIEval.obj"
	-@erase "$(INTDIR)\MPerfProcApps.obj"
	-@erase "$(INTDIR)\MPerfStationClass.obj"
	-@erase "$(INTDIR)\MPerfStationLocation.obj"
	-@erase "$(INTDIR)\MPerfStationName.obj"
	-@erase "$(INTDIR)\MPerfWorkitem.obj"
	-@erase "$(INTDIR)\MPlacerOrder.obj"
	-@erase "$(INTDIR)\MPPSAssistant.obj"
	-@erase "$(INTDIR)\MQRObjects.obj"
	-@erase "$(INTDIR)\MRefGPSPS.obj"
	-@erase "$(INTDIR)\MReqSubsWorkitem.obj"
	-@erase "$(INTDIR)\MRequestAttribute.obj"
	-@erase "$(INTDIR)\MRequestedProcedure.obj"
	-@erase "$(INTDIR)\MSchedule.obj"
	-@erase "$(INTDIR)\MSeries.obj"
	-@erase "$(INTDIR)\MServerAgent.obj"
	-@erase "$(INTDIR)\msgcond.obj"
	-@erase "$(INTDIR)\MSOPHandler.obj"
	-@erase "$(INTDIR)\MSOPInstance.obj"
	-@erase "$(INTDIR)\MSOPStorageHandler.obj"
	-@erase "$(INTDIR)\MSPS.obj"
	-@erase "$(INTDIR)\MSRContentItem.obj"
	-@erase "$(INTDIR)\MSRContentItemCode.obj"
	-@erase "$(INTDIR)\MSRContentItemContainer.obj"
	-@erase "$(INTDIR)\MSRContentItemFactory.obj"
	-@erase "$(INTDIR)\MSRContentItemImage.obj"
	-@erase "$(INTDIR)\MSRContentItemPName.obj"
	-@erase "$(INTDIR)\MSRContentItemText.obj"
	-@erase "$(INTDIR)\MSREval.obj"
	-@erase "$(INTDIR)\MSREvalTID2000.obj"
	-@erase "$(INTDIR)\MSRWrapper.obj"
	-@erase "$(INTDIR)\MStationClass.obj"
	-@erase "$(INTDIR)\MStationLocation.obj"
	-@erase "$(INTDIR)\MStationName.obj"
	-@erase "$(INTDIR)\MStorageAgent.obj"
	-@erase "$(INTDIR)\MStorageCommitItem.obj"
	-@erase "$(INTDIR)\MStorageCommitRequest.obj"
	-@erase "$(INTDIR)\MStorageCommitResponse.obj"
	-@erase "$(INTDIR)\MString.obj"
	-@erase "$(INTDIR)\MStudy.obj"
	-@erase "$(INTDIR)\MSyslogClient.obj"
	-@erase "$(INTDIR)\MSyslogDomainXlate.obj"
	-@erase "$(INTDIR)\MSyslogEntry.obj"
	-@erase "$(INTDIR)\MSyslogFactory.obj"
	-@erase "$(INTDIR)\MSyslogMessage.obj"
	-@erase "$(INTDIR)\MSyslogMessage5424.obj"
	-@erase "$(INTDIR)\MUWLScheduledStationNameCode.obj"
	-@erase "$(INTDIR)\MUPS.obj"
	-@erase "$(INTDIR)\MUPSObjects.obj"
	-@erase "$(INTDIR)\MVisit.obj"
	-@erase "$(INTDIR)\MWorkOrder.obj"
	-@erase "$(INTDIR)\MWrapperFactory.obj"
	-@erase "$(INTDIR)\naction.obj"
	-@erase "$(INTDIR)\ncreate.obj"
	-@erase "$(INTDIR)\ndelete.obj"
	-@erase "$(INTDIR)\neventreport.obj"
	-@erase "$(INTDIR)\nget.obj"
	-@erase "$(INTDIR)\nset.obj"
	-@erase "$(INTDIR)\print.obj"
	-@erase "$(INTDIR)\printcond.obj"
	-@erase "$(INTDIR)\private.obj"
	-@erase "$(INTDIR)\record.obj"
	-@erase "$(INTDIR)\select.obj"
	-@erase "$(INTDIR)\send.obj"
	-@erase "$(INTDIR)\sequences.obj"
	-@erase "$(INTDIR)\set.obj"
	-@erase "$(INTDIR)\sqcond.obj"
	-@erase "$(INTDIR)\srv1.obj"
	-@erase "$(INTDIR)\srv2.obj"
	-@erase "$(INTDIR)\srvcond.obj"
	-@erase "$(INTDIR)\storage.obj"
	-@erase "$(INTDIR)\string-lib.obj"
	-@erase "$(INTDIR)\tbl_sqlserver.obj"
	-@erase "$(INTDIR)\tblcond.obj"
	-@erase "$(INTDIR)\thrcond.obj"
	-@erase "$(INTDIR)\uid.obj"
	-@erase "$(INTDIR)\uidcond.obj"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\utility.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\verify.obj"
	-@erase "$(OUTDIR)\mesa_lib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MDd /w /W0 /Gm /EHsc /ZI /Od /I "..\..\..\ctn\include" /I "..\..\include" /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /Fp"$(INTDIR)\mesa_lib.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mesa_lib.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"$(OUTDIR)\mesa_lib.lib" 
LIB32_OBJS= \
	"$(INTDIR)\build.obj" \
	"$(INTDIR)\cgi-lib.obj" \
	"$(INTDIR)\cgi-llist.obj" \
	"$(INTDIR)\cmd_valid.obj" \
	"$(INTDIR)\condition.obj" \
	"$(INTDIR)\control.obj" \
	"$(INTDIR)\ctnthread.obj" \
	"$(INTDIR)\dcm.obj" \
	"$(INTDIR)\dcm1.obj" \
	"$(INTDIR)\dcmcond.obj" \
	"$(INTDIR)\dcmdict.obj" \
	"$(INTDIR)\dcmsupport.obj" \
	"$(INTDIR)\ddr.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\dicom_chr.obj" \
	"$(INTDIR)\dulcond.obj" \
	"$(INTDIR)\dulconstruct.obj" \
	"$(INTDIR)\dulfsm.obj" \
	"$(INTDIR)\dulparse.obj" \
	"$(INTDIR)\dulpresent.obj" \
	"$(INTDIR)\dulprotocol.obj" \
	"$(INTDIR)\dump.obj" \
	"$(INTDIR)\event.obj" \
	"$(INTDIR)\find.obj" \
	"$(INTDIR)\fis.obj" \
	"$(INTDIR)\fiscond.obj" \
	"$(INTDIR)\fisdelete.obj" \
	"$(INTDIR)\fisget.obj" \
	"$(INTDIR)\fisinsert.obj" \
	"$(INTDIR)\get.obj" \
	"$(INTDIR)\gq.obj" \
	"$(INTDIR)\hl7_api.obj" \
	"$(INTDIR)\iap.obj" \
	"$(INTDIR)\iapcond.obj" \
	"$(INTDIR)\idb.obj" \
	"$(INTDIR)\idbcond.obj" \
	"$(INTDIR)\ie.obj" \
	"$(INTDIR)\iecond.obj" \
	"$(INTDIR)\insert.obj" \
	"$(INTDIR)\lst.obj" \
	"$(INTDIR)\lstcond.obj" \
	"$(INTDIR)\MAcceptor.obj" \
	"$(INTDIR)\MActHumanPerformers.obj" \
	"$(INTDIR)\MActionItem.obj" \
	"$(INTDIR)\mancond.obj" \
	"$(INTDIR)\MApplicationEntity.obj" \
	"$(INTDIR)\MAuditMessage.obj" \
	"$(INTDIR)\MAuditMessageFactory.obj" \
	"$(INTDIR)\MCharsetEncoder.obj" \
	"$(INTDIR)\MCodeItem.obj" \
	"$(INTDIR)\MCommonOrder.obj" \
	"$(INTDIR)\MCompositeEval.obj" \
	"$(INTDIR)\MCompositeObjectFactory.obj" \
	"$(INTDIR)\MConfigFile.obj" \
	"$(INTDIR)\MConnector.obj" \
	"$(INTDIR)\MDateTime.obj" \
	"$(INTDIR)\MDBADT.obj" \
	"$(INTDIR)\MDBBase.obj" \
	"$(INTDIR)\MDBImageManager.obj" \
	"$(INTDIR)\MDBImageManagerJapanese.obj" \
	"$(INTDIR)\MDBImageManagerStudy.obj" \
	"$(INTDIR)\MDBIMClient.obj" \
	"$(INTDIR)\MDBInterface.obj" \
	"$(INTDIR)\MDBModality.obj" \
	"$(INTDIR)\MDBOFClient.obj" \
	"$(INTDIR)\MDBOrderFiller.obj" \
	"$(INTDIR)\MDBOrderFillerBase.obj" \
	"$(INTDIR)\MDBOrderFillerJapanese.obj" \
	"$(INTDIR)\MDBOrderPlacer.obj" \
	"$(INTDIR)\MDBOrderPlacerJapanese.obj" \
	"$(INTDIR)\MDBPostProcMgr.obj" \
	"$(INTDIR)\MDBPostProcMgrClient.obj" \
	"$(INTDIR)\MDBSyslogManager.obj" \
	"$(INTDIR)\MDBXRefMgr.obj" \
	"$(INTDIR)\MDDRFile.obj" \
	"$(INTDIR)\MDICOMApp.obj" \
	"$(INTDIR)\MDICOMAssociation.obj" \
	"$(INTDIR)\MDICOMAttribute.obj" \
	"$(INTDIR)\MDICOMConfig.obj" \
	"$(INTDIR)\MDICOMDir.obj" \
	"$(INTDIR)\MDICOMDomainXlate.obj" \
	"$(INTDIR)\MDICOMElementEval.obj" \
	"$(INTDIR)\MDICOMFileMeta.obj" \
	"$(INTDIR)\MDICOMProxy.obj" \
	"$(INTDIR)\MDICOMProxyTCP.obj" \
	"$(INTDIR)\MDICOMReactor.obj" \
	"$(INTDIR)\MDICOMWrapper.obj" \
	"$(INTDIR)\MDomainObject.obj" \
	"$(INTDIR)\messages.obj" \
	"$(INTDIR)\MFileOperations.obj" \
	"$(INTDIR)\MFillerOrder.obj" \
	"$(INTDIR)\MGPPPSObject.obj" \
	"$(INTDIR)\MGPPPSWorkitem.obj" \
	"$(INTDIR)\MGPSPSObject.obj" \
	"$(INTDIR)\MGPWorkitem.obj" \
	"$(INTDIR)\MGPWorkitemObject.obj" \
	"$(INTDIR)\MHL7Compare.obj" \
	"$(INTDIR)\MHL7Dispatcher.obj" \
	"$(INTDIR)\MHL7DomainXlate.obj" \
	"$(INTDIR)\MHL7Factory.obj" \
	"$(INTDIR)\MHL7MessageControlID.obj" \
	"$(INTDIR)\MHL7Msg.obj" \
	"$(INTDIR)\MHL7ProtocolHandlerLLP.obj" \
	"$(INTDIR)\MHL7Reactor.obj" \
	"$(INTDIR)\MHL7Speaker.obj" \
	"$(INTDIR)\MHL7Validator.obj" \
	"$(INTDIR)\MIdentifier.obj" \
	"$(INTDIR)\MInputInfo.obj" \
	"$(INTDIR)\MIssuer.obj" \
	"$(INTDIR)\MLogClient.obj" \
	"$(INTDIR)\MMESAMisc.obj" \
	"$(INTDIR)\MMPPS.obj" \
	"$(INTDIR)\MMWL.obj" \
	"$(INTDIR)\MMWLObjects.obj" \
	"$(INTDIR)\MNetworkProxy.obj" \
	"$(INTDIR)\MNetworkProxyTCP.obj" \
	"$(INTDIR)\MNonDCMOutput.obj" \
	"$(INTDIR)\MObservationRequest.obj" \
	"$(INTDIR)\MOrder.obj" \
	"$(INTDIR)\MOutputInfo.obj" \
	"$(INTDIR)\move.obj" \
	"$(INTDIR)\MPatient.obj" \
	"$(INTDIR)\MPatientStudy.obj" \
	"$(INTDIR)\MPDIEval.obj" \
	"$(INTDIR)\MPerfProcApps.obj" \
	"$(INTDIR)\MPerfStationClass.obj" \
	"$(INTDIR)\MPerfStationLocation.obj" \
	"$(INTDIR)\MPerfStationName.obj" \
	"$(INTDIR)\MPerfWorkitem.obj" \
	"$(INTDIR)\MPlacerOrder.obj" \
	"$(INTDIR)\MPPSAssistant.obj" \
	"$(INTDIR)\MQRObjects.obj" \
	"$(INTDIR)\MRefGPSPS.obj" \
	"$(INTDIR)\MReqSubsWorkitem.obj" \
	"$(INTDIR)\MRequestAttribute.obj" \
	"$(INTDIR)\MRequestedProcedure.obj" \
	"$(INTDIR)\MSchedule.obj" \
	"$(INTDIR)\MSeries.obj" \
	"$(INTDIR)\MServerAgent.obj" \
	"$(INTDIR)\msgcond.obj" \
	"$(INTDIR)\MSOPHandler.obj" \
	"$(INTDIR)\MSOPInstance.obj" \
	"$(INTDIR)\MSOPStorageHandler.obj" \
	"$(INTDIR)\MSPS.obj" \
	"$(INTDIR)\MSRContentItem.obj" \
	"$(INTDIR)\MSRContentItemCode.obj" \
	"$(INTDIR)\MSRContentItemContainer.obj" \
	"$(INTDIR)\MSRContentItemFactory.obj" \
	"$(INTDIR)\MSRContentItemImage.obj" \
	"$(INTDIR)\MSRContentItemPName.obj" \
	"$(INTDIR)\MSRContentItemText.obj" \
	"$(INTDIR)\MSREval.obj" \
	"$(INTDIR)\MSREvalTID2000.obj" \
	"$(INTDIR)\MSRWrapper.obj" \
	"$(INTDIR)\MStationClass.obj" \
	"$(INTDIR)\MStationLocation.obj" \
	"$(INTDIR)\MStationName.obj" \
	"$(INTDIR)\MStorageAgent.obj" \
	"$(INTDIR)\MStorageCommitItem.obj" \
	"$(INTDIR)\MStorageCommitRequest.obj" \
	"$(INTDIR)\MStorageCommitResponse.obj" \
	"$(INTDIR)\MString.obj" \
	"$(INTDIR)\MStudy.obj" \
	"$(INTDIR)\MSyslogClient.obj" \
	"$(INTDIR)\MSyslogDomainXlate.obj" \
	"$(INTDIR)\MSyslogEntry.obj" \
	"$(INTDIR)\MSyslogFactory.obj" \
	"$(INTDIR)\MSyslogMessage.obj" \
	"$(INTDIR)\MSyslogMessage5424.obj" \
	"$(INTDIR)\MUWLScheduledStationNameCode.obj" \
	"$(INTDIR)\MUPS.obj" \
	"$(INTDIR)\MUPSObjects.obj" \
	"$(INTDIR)\MVisit.obj" \
	"$(INTDIR)\MWorkOrder.obj" \
	"$(INTDIR)\MWrapperFactory.obj" \
	"$(INTDIR)\naction.obj" \
	"$(INTDIR)\ncreate.obj" \
	"$(INTDIR)\ndelete.obj" \
	"$(INTDIR)\neventreport.obj" \
	"$(INTDIR)\nget.obj" \
	"$(INTDIR)\nset.obj" \
	"$(INTDIR)\print.obj" \
	"$(INTDIR)\printcond.obj" \
	"$(INTDIR)\private.obj" \
	"$(INTDIR)\record.obj" \
	"$(INTDIR)\select.obj" \
	"$(INTDIR)\send.obj" \
	"$(INTDIR)\sequences.obj" \
	"$(INTDIR)\set.obj" \
	"$(INTDIR)\sqcond.obj" \
	"$(INTDIR)\srv1.obj" \
	"$(INTDIR)\srv2.obj" \
	"$(INTDIR)\srvcond.obj" \
	"$(INTDIR)\storage.obj" \
	"$(INTDIR)\string-lib.obj" \
	"$(INTDIR)\tbl_sqlserver.obj" \
	"$(INTDIR)\tblcond.obj" \
	"$(INTDIR)\thrcond.obj" \
	"$(INTDIR)\uid.obj" \
	"$(INTDIR)\uidcond.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\utility.obj" \
	"$(INTDIR)\verify.obj" \
	"$(INTDIR)\MDBPDSupplier.obj"

"$(OUTDIR)\mesa_lib.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
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
!IF EXISTS("mesa_lib.dep")
!INCLUDE "mesa_lib.dep"
!ELSE 
!MESSAGE Warning: cannot find "mesa_lib.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mesa_lib - Win32 Release" || "$(CFG)" == "mesa_lib - Win32 Debug"
SOURCE=..\..\..\ctn\facilities\fis\build.c

"$(INTDIR)\build.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE="..\..\external\cgihtml-1.69\cgi-lib.c"

"$(INTDIR)\cgi-lib.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE="..\..\external\cgihtml-1.69\cgi-llist.c"

"$(INTDIR)\cgi-llist.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\cmd_valid.c

"$(INTDIR)\cmd_valid.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\condition\condition.c

"$(INTDIR)\condition.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\manage\control.c

"$(INTDIR)\control.obj" : $(SOURCE) "$(INTDIR)"
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


SOURCE=..\..\..\ctn\facilities\manage\delete.c

"$(INTDIR)\delete.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\chr\dicom_chr.c

"$(INTDIR)\dicom_chr.obj" : $(SOURCE) "$(INTDIR)"
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


SOURCE=..\..\..\ctn\facilities\fis\event.c

"$(INTDIR)\event.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\find.c

"$(INTDIR)\find.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\fis.c

"$(INTDIR)\fis.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\fiscond.c

"$(INTDIR)\fiscond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\fisdelete.c

"$(INTDIR)\fisdelete.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\fisget.c

"$(INTDIR)\fisget.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\fisinsert.c

"$(INTDIR)\fisinsert.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\get.c

"$(INTDIR)\get.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\gq\gq.c

"$(INTDIR)\gq.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\external\hl7\hl7_api.c

"$(INTDIR)\hl7_api.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\iap\iap.c

"$(INTDIR)\iap.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\iap\iapcond.c

"$(INTDIR)\iapcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\idb\idb.c

"$(INTDIR)\idb.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\idb\idbcond.c

"$(INTDIR)\idbcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\info_entity\ie.c

"$(INTDIR)\ie.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\info_entity\iecond.c

"$(INTDIR)\iecond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\manage\insert.c

"$(INTDIR)\insert.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\lst\lst.c

"$(INTDIR)\lst.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\lst\lstcond.c

"$(INTDIR)\lstcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MAcceptor.cpp

"$(INTDIR)\MAcceptor.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MActHumanPerformers.cpp

"$(INTDIR)\MActHumanPerformers.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MActionItem.cpp

"$(INTDIR)\MActionItem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\manage\mancond.c

"$(INTDIR)\mancond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MApplicationEntity.cpp

"$(INTDIR)\MApplicationEntity.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\syslog\MAuditMessage.cpp

"$(INTDIR)\MAuditMessage.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\syslog\MAuditMessageFactory.cpp

"$(INTDIR)\MAuditMessageFactory.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MCharsetEncoder.cpp

"$(INTDIR)\MCharsetEncoder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MCodeItem.cpp

"$(INTDIR)\MCodeItem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MCommonOrder.cpp

"$(INTDIR)\MCommonOrder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MCompositeEval.cpp

"$(INTDIR)\MCompositeEval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MCompositeObjectFactory.cpp

"$(INTDIR)\MCompositeObjectFactory.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MConfigFile.cpp

"$(INTDIR)\MConfigFile.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MConnector.cpp

"$(INTDIR)\MConnector.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MDateTime.cpp

"$(INTDIR)\MDateTime.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBADT.cpp

"$(INTDIR)\MDBADT.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBBase.cpp

"$(INTDIR)\MDBBase.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBImageManager.cpp

"$(INTDIR)\MDBImageManager.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBImageManagerJapanese.cpp

"$(INTDIR)\MDBImageManagerJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBImageManagerStudy.cpp

"$(INTDIR)\MDBImageManagerStudy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBIMClient.cpp

"$(INTDIR)\MDBIMClient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBInterface.cpp

"$(INTDIR)\MDBInterface.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBModality.cpp

"$(INTDIR)\MDBModality.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOFClient.cpp

"$(INTDIR)\MDBOFClient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOrderFiller.cpp

"$(INTDIR)\MDBOrderFiller.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOrderFillerBase.cpp

"$(INTDIR)\MDBOrderFillerBase.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOrderFillerJapanese.cpp

"$(INTDIR)\MDBOrderFillerJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOrderPlacer.cpp

"$(INTDIR)\MDBOrderPlacer.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBOrderPlacerJapanese.cpp

"$(INTDIR)\MDBOrderPlacerJapanese.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBPDSupplier.cpp

"$(INTDIR)\MDBPDSupplier.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBPostProcMgr.cpp

"$(INTDIR)\MDBPostProcMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBPostProcMgrClient.cpp

"$(INTDIR)\MDBPostProcMgrClient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBSyslogManager.cpp

"$(INTDIR)\MDBSyslogManager.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDBXRefMgr.cpp

"$(INTDIR)\MDBXRefMgr.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDDRFile.cpp

"$(INTDIR)\MDDRFile.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDICOMApp.cpp

"$(INTDIR)\MDICOMApp.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMAssociation.cpp

"$(INTDIR)\MDICOMAssociation.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMAttribute.cpp

"$(INTDIR)\MDICOMAttribute.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMConfig.cpp

"$(INTDIR)\MDICOMConfig.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDICOMDir.cpp

"$(INTDIR)\MDICOMDir.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\translators\MDICOMDomainXlate.cpp

"$(INTDIR)\MDICOMDomainXlate.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MDICOMElementEval.cpp

"$(INTDIR)\MDICOMElementEval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDICOMFileMeta.cpp

"$(INTDIR)\MDICOMFileMeta.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMProxy.cpp

"$(INTDIR)\MDICOMProxy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMProxyTCP.cpp

"$(INTDIR)\MDICOMProxyTCP.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMReactor.cpp

"$(INTDIR)\MDICOMReactor.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MDICOMWrapper.cpp

"$(INTDIR)\MDICOMWrapper.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MDomainObject.cpp

"$(INTDIR)\MDomainObject.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\messages.c

"$(INTDIR)\messages.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MFileOperations.cpp

"$(INTDIR)\MFileOperations.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MFillerOrder.cpp

"$(INTDIR)\MFillerOrder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MGPPPSObject.cpp

"$(INTDIR)\MGPPPSObject.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MGPPPSWorkitem.cpp

"$(INTDIR)\MGPPPSWorkitem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MGPSPSObject.cpp

"$(INTDIR)\MGPSPSObject.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MGPWorkitem.cpp

"$(INTDIR)\MGPWorkitem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MGPWorkitemObject.cpp

"$(INTDIR)\MGPWorkitemObject.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Compare.cpp

"$(INTDIR)\MHL7Compare.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Dispatcher.cpp

"$(INTDIR)\MHL7Dispatcher.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\translators\MHL7DomainXlate.cpp

"$(INTDIR)\MHL7DomainXlate.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Factory.cpp

"$(INTDIR)\MHL7Factory.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7MessageControlID.cpp

"$(INTDIR)\MHL7MessageControlID.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Msg.cpp

"$(INTDIR)\MHL7Msg.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7ProtocolHandlerLLP.cpp

"$(INTDIR)\MHL7ProtocolHandlerLLP.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Reactor.cpp

"$(INTDIR)\MHL7Reactor.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Speaker.cpp

"$(INTDIR)\MHL7Speaker.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\hl7\MHL7Validator.cpp

"$(INTDIR)\MHL7Validator.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MIdentifier.cpp

"$(INTDIR)\MIdentifier.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MInputInfo.cpp

"$(INTDIR)\MInputInfo.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MIssuer.cpp

"$(INTDIR)\MIssuer.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MLogClient.cpp

"$(INTDIR)\MLogClient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MMESAMisc.cpp

"$(INTDIR)\MMESAMisc.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MMPPS.cpp

"$(INTDIR)\MMPPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MMWL.cpp

"$(INTDIR)\MMWL.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MMWLObjects.cpp

"$(INTDIR)\MMWLObjects.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\libsrc\domain\MUWLScheduledStationNameCode.cpp

"$(INTDIR)\MUWLScheduledStationNameCode.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\libsrc\domain\MUPS.cpp

"$(INTDIR)\MUPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\libsrc\domain\MUPSObjects.cpp

"$(INTDIR)\MUPSObjects.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MNetworkProxy.cpp

"$(INTDIR)\MNetworkProxy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MNetworkProxyTCP.cpp

"$(INTDIR)\MNetworkProxyTCP.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MNonDCMOutput.cpp

"$(INTDIR)\MNonDCMOutput.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MObservationRequest.cpp

"$(INTDIR)\MObservationRequest.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MOrder.cpp

"$(INTDIR)\MOrder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MOutputInfo.cpp

"$(INTDIR)\MOutputInfo.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\move.c

"$(INTDIR)\move.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPatient.cpp

"$(INTDIR)\MPatient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPatientStudy.cpp

"$(INTDIR)\MPatientStudy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MPDIEval.cpp

"$(INTDIR)\MPDIEval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPerfProcApps.cpp

"$(INTDIR)\MPerfProcApps.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPerfStationClass.cpp

"$(INTDIR)\MPerfStationClass.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPerfStationLocation.cpp

"$(INTDIR)\MPerfStationLocation.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPerfStationName.cpp

"$(INTDIR)\MPerfStationName.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPerfWorkitem.cpp

"$(INTDIR)\MPerfWorkitem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MPlacerOrder.cpp

"$(INTDIR)\MPlacerOrder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MPPSAssistant.cpp

"$(INTDIR)\MPPSAssistant.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MQRObjects.cpp

"$(INTDIR)\MQRObjects.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MRefGPSPS.cpp

"$(INTDIR)\MRefGPSPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MReqSubsWorkitem.cpp

"$(INTDIR)\MReqSubsWorkitem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MRequestAttribute.cpp

"$(INTDIR)\MRequestAttribute.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MRequestedProcedure.cpp

"$(INTDIR)\MRequestedProcedure.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MSchedule.cpp

"$(INTDIR)\MSchedule.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MSeries.cpp

"$(INTDIR)\MSeries.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MServerAgent.cpp

"$(INTDIR)\MServerAgent.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\messages\msgcond.c

"$(INTDIR)\msgcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MSOPHandler.cpp

"$(INTDIR)\MSOPHandler.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MSOPInstance.cpp

"$(INTDIR)\MSOPInstance.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MSOPStorageHandler.cpp

"$(INTDIR)\MSOPStorageHandler.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MSPS.cpp

"$(INTDIR)\MSPS.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItem.cpp

"$(INTDIR)\MSRContentItem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemCode.cpp

"$(INTDIR)\MSRContentItemCode.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemContainer.cpp

"$(INTDIR)\MSRContentItemContainer.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemFactory.cpp

"$(INTDIR)\MSRContentItemFactory.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemImage.cpp

"$(INTDIR)\MSRContentItemImage.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemPName.cpp

"$(INTDIR)\MSRContentItemPName.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRContentItemText.cpp

"$(INTDIR)\MSRContentItemText.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MSREval.cpp

"$(INTDIR)\MSREval.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\meval\MSREvalTID2000.cpp

"$(INTDIR)\MSREvalTID2000.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\sr\MSRWrapper.cpp

"$(INTDIR)\MSRWrapper.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStationClass.cpp

"$(INTDIR)\MStationClass.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStationLocation.cpp

"$(INTDIR)\MStationLocation.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStationName.cpp

"$(INTDIR)\MStationName.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MStorageAgent.cpp

"$(INTDIR)\MStorageAgent.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStorageCommitItem.cpp

"$(INTDIR)\MStorageCommitItem.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStorageCommitRequest.cpp

"$(INTDIR)\MStorageCommitRequest.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStorageCommitResponse.cpp

"$(INTDIR)\MStorageCommitResponse.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\common\MString.cpp

"$(INTDIR)\MString.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MStudy.cpp

"$(INTDIR)\MStudy.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\syslog\MSyslogClient.cpp

"$(INTDIR)\MSyslogClient.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\translators\MSyslogDomainXlate.cpp

"$(INTDIR)\MSyslogDomainXlate.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MSyslogEntry.cpp

"$(INTDIR)\MSyslogEntry.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\syslog\MSyslogFactory.cpp

"$(INTDIR)\MSyslogFactory.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\syslog\MSyslogMessage.cpp

"$(INTDIR)\MSyslogMessage.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=..\..\libsrc\syslog\MSyslogMessage5424.cpp

"$(INTDIR)\MSyslogMessage5424.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MVisit.cpp

"$(INTDIR)\MVisit.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\domain\MWorkOrder.cpp

"$(INTDIR)\MWorkOrder.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\libsrc\cxxctn\MWrapperFactory.cpp

"$(INTDIR)\MWrapperFactory.obj" : $(SOURCE) "$(INTDIR)"
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


SOURCE=..\..\..\ctn\facilities\print\print.c

"$(INTDIR)\print.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\print\printcond.c

"$(INTDIR)\printcond.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\private.c

"$(INTDIR)\private.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\fis\record.c

"$(INTDIR)\record.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\manage\select.c

"$(INTDIR)\select.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\send.c

"$(INTDIR)\send.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\sq\sequences.c

"$(INTDIR)\sequences.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\manage\set.c

"$(INTDIR)\set.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\sq\sqcond.c

"$(INTDIR)\sqcond.obj" : $(SOURCE) "$(INTDIR)"
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


SOURCE="..\..\external\cgihtml-1.69\string-lib.c"

"$(INTDIR)\string-lib.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\tbl\tbl_sqlserver.c

"$(INTDIR)\tbl_sqlserver.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\tbl\tblcond.c

"$(INTDIR)\tblcond.obj" : $(SOURCE) "$(INTDIR)"
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


SOURCE=..\..\..\ctn\facilities\fis\update.c

"$(INTDIR)\update.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\utility\utility.c

"$(INTDIR)\utility.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=..\..\..\ctn\facilities\services\verify.c

"$(INTDIR)\verify.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

