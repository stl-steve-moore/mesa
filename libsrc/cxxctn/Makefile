include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

CLASS_FILES = MApplicationEntity MCompositeObjectFactory \
	MDICOMAssociation MDICOMConfig MDDRFile \
	MDICOMProxy MDICOMProxyTCP MDICOMReactor MDICOMWrapper MPPSAssistant \
	MSOPHandler MSOPStorageHandler \
	MStorageAgent MWrapperFactory

HEADERS = $(CLASS_FILES:=.hpp)
OBJS = $(CLASS_FILES:=.o)

libcxxctn.a: $(OBJS)
	ar cvr libcxxctn.a $(OBJS)

install:	libcxxctn.a
	cp libcxxctn.a $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)

MApplicationEntity.o: MApplicationEntity.cpp MApplicationEntity.hpp
MDICOMConfig.o: MDICOMConfig.cpp MDICOMConfig.hpp
MDDRFile.o: MDDRFile.cpp MDDRFile.hpp 
MDICOMProxy.o: MDICOMProxy.cpp MDICOMProxy.hpp
MDICOMProxyTCP.o: MDICOMProxyTCP.cpp MDICOMProxyTCP.hpp
MDICOMReactor.o: MDICOMReactor.cpp MDICOMReactor.hpp
MPPSAssistant.o: MPPSAssistant.cpp MPPSAssistant.hpp
MSOPHandler.o: MSOPHandler.cpp MSOPHandler.hpp
MSOPStorageHandler.o: MSOPStorageHandler.cpp MSOPStorageHandler.hpp
MStorageAgent.o: MStorageAgent.cpp MStorageAgent.hpp

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/cxxctn

clean:
	rm -rf Template.DB libcxxctn.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
