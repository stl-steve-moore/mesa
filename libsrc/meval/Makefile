include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

CLASS_FILES = MCompositeEval MDICOMElementEval MPDIEval MSREval MSREvalTID2000

HEADERS = $(CLASS_FILES:=.hpp)
OBJS = $(CLASS_FILES:=.o)

libmeval.a: $(OBJS)
	ar cvr libmeval.a $(OBJS)

install:	libmeval.a
	cp libmeval.a $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MEval.hpp $(MESA_INCLUDE)

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/meval

clean:
	rm -rf Template.DB libmeval.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
	$(INSTALLINCLUDE) MEval.hpp $(MESA_INCLUDE)
