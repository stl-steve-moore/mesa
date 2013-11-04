# Makefile for dir:/mesa/libsrc/domain

# Makes Mesa's hl7 library and installs the header files
# into mesa/include

include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

LIB = libdomain.a

CLASS_FILES = MDBADT \
	MDBDeptSysSched \
        MDBImageManager \
        MDBImageManagerJapanese \
	MDBImageManagerStudy \
        MDBIMClient \
        MDBModality \
	MDBOFClient \
	MDBOrderFillerBase \
	MDBOrderFiller \
	MDBOrderFillerJapanese \
	MDBOrderPlacer \
	MDBOrderPlacerJapanese \
	MDBPDSupplier \
	MDBXRefMgr \
        MDBBase \
        MDBInterface \
        MDBSyslogManager \
	MDICOMApp \
	MDICOMDir MDICOMFileMeta \
	MDomainObject \
	MIdentifier \
	MIssuer \
	MCodeItem MActionItem \
	MFillerOrder MMWL \
	MSchedule MPatient MPatientStudy MQRObjects MVisit MOrder MPlacerOrder \
        MMPPS MMWLObjects MRequestedProcedure \
	MRequestAttribute \
        MSeries MSOPInstance MSPS MStudy \
	MStorageCommitItem \
	MStorageCommitRequest \
	MStorageCommitResponse \
	MSyslogEntry \
	MWorkOrder \
	MReferencedRequest \
	MGPWorkitem MGPWorkitemObject \
	MStationName MStationClass  MPerfStationName MPerfStationClass \
	MStationLocation MPerfStationLocation \
	MPerfProcApps MPerfWorkitem \
	MReqSubsWorkitem MOutputInfo MNonDCMOutput MInputInfo \
	MGPPPSWorkitem MRefGPSPS MActHumanPerformers \
	MGPSPSObject MGPPPSObject \
	MDBPostProcMgr MDBPostProcMgrClient MUPS MUPSObjects \
	MUWLScheduledStationNameCode

#MCommonOrder
#MObservationRequest 

OBJS = $(CLASS_FILES:=.o)		#List of the object files
HEADERS = $(CLASS_FILES:=.hpp)	#List of the header files

# Targets
#######################

$(LIB): $(OBJS)
	ar cvr $(LIB) $(OBJS)

install: $(LIB)
	cp $(LIB) $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/domain

clean:
	rm -rf Template.DB $(LIB) $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
