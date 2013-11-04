include $(MESA_MAKE)

CFLAGS = $(C_OPTS) 
CXX_FLAGS = $(C_OPTS) 

CLASS_FILES = MAuditMessage MAuditMessageFactory MDICOMAuditMessage \
MSyslogClient MSyslogFactory MSyslogMessage MSyslogMessage5424 \
MBeginTransferDICOMInstances

CLASS_FILES_SECURE = MAuditMessage MAuditMessageFactory MDICOMAuditMessage \
MSyslogFactory MSyslogMessage MSyslogMessage5424 \
MBeginTransferDICOMInstances

OBJS = $(CLASS_FILES:=.o)
HEADERS = $(CLASS_FILES:=.hpp)

OBJS_SECURE = $(CLASS_FILES_SECURE:=.o) MSyslogClientSecure.o
HEADERS_SECURE = $(CLASS_FILES_SECURE:=.hpp)

libsyslog.a: $(OBJS) $(HEADERS)
	ar cvr libsyslog.a $(OBJS)

libsyslog_secure.a: $(OBJS_SECURE) $(HEADERS)
	ar cvr libsyslog_secure.a $(OBJS_SECURE)

MAuditMessage.o: MAuditMessage.cpp MAuditMessage.hpp

MAuditMessageFactory.o: MAuditMessageFactory.cpp MAuditMessageFactory.hpp

MDICOMAuditMessage.o: MDICOMAuditMessage.cpp MDICOMAuditMessage.hpp

MSyslogClient.o: MSyslogClient.cpp MSyslogClient.hpp

MSyslogClientSecure.o: MSyslogClient.cpp MSyslogClient.hpp
	$(CXX) -o MSyslogClientSecure.o -DRFC5425 $(CXX_FLAGS) $(INCLUDES) -c MSyslogClient.cpp


MSyslogFactory.o: MSyslogFactory.cpp MSyslogFactory.hpp

MSyslogMessage.o: MSyslogMessage.cpp MSyslogMessage.hpp

MSyslogMessage5424.o: MSyslogMessage5424.cpp MSyslogMessage5424.hpp

# Start the audit events
MBeginTransferDICOMInstances.o: MBeginTransferDICOMInstances.cpp MBeginTransferDICOMInstances.hpp

install: libsyslog.a
	cp libsyslog.a $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)

install_secure: libsyslog_secure.a
	cp libsyslog_secure.a $(MESA_LIB)/libsyslog.a
	$(INSTALLINCLUDE) $(HEADERS_SECURE) $(MESA_INCLUDE)

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/syslog

clean:
	rm -rf Template.DB libsyslog.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) MSyslogMessage.hpp $(MESA_INCLUDE)
