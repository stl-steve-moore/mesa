include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

CLASS_FILES = MDICOMDomainXlate MHL7DomainXlate MSyslogDomainXlate

OBJS = $(CLASS_FILES:=.o)
HEADERS = $(CLASS_FILES:=.hpp)

libtranslators.a: $(OBJS)
	ar cvr libtranslators.a $(OBJS)

MHL7DomainXlate.o: MHL7DomainXlate.cpp MHL7DomainXlate.hpp

install:	libtranslators.a
	cp libtranslators.a $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/translators

clean:
	rm -rf Template.DB libtranslators.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) MDICOMDomainXlate.hpp $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MHL7DomainXlate.hpp $(MESA_INCLUDE)
