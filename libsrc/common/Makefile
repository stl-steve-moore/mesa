include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

CLASS_FILES = MAcceptor MCharsetEncoder MCGIParser MConnector MConfigFile MDateTime \
MFileOperations MLogClient MMESAMisc MNetworkProxy MNetworkProxyTCP MString MServerAgent MBase64

OBJS = $(CLASS_FILES:=.o)
HEADERS = $(CLASS_FILES:=.hpp)

libcommon.a: $(OBJS)
	ar cvr libcommon.a $(OBJS)

MAcceptor.o: MAcceptor.cpp MAcceptor.hpp
MCharsetEncoder.o: MCharsetEncoder.cpp MCharsetEncoder.hpp
MCGIParser.o: MCGIParser.cpp MCGIParser.hpp
MConnector.o: MConnector.cpp MConnector.hpp
MConfigFile.o: MConfigFile.cpp MConfigFile.hpp
MDateTime.o: MDateTime.cpp MDateTime.hpp
MFileOperations.o: MFileOperations.cpp MFileOperations.hpp
MLogClient.o: MLogClient.cpp MLogClient.hpp
MNetworkProxy.o: MNetworkProxy.cpp MNetworkProxy.hpp
MNetworkProxyTCP.o: MNetworkProxyTCP.cpp MNetworkProxyTCP.hpp MNetworkProxy.hpp
MString.o: MString.cpp MString.hpp
MServerAgent.o: MServerAgent.cpp MServerAgent.hpp
MBase64.o : MBase64.cpp MBase64.hpp

install: libcommon.a
	cp libcommon.a $(MESA_LIB)
	$(INSTALLINCLUDE) MESA.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
	$(INSTALLINCLUDE) ctn_api.h $(MESA_INCLUDE)

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/common

clean:
	rm -rf Template.DB libcommon.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) MESA.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MAcceptor.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MFileOperations.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MLogClient.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MString.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MServerAgent.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) ctn_api.h $(MESA_INCLUDE)

