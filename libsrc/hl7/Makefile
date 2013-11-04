# Makefile for dir:/mesa/libsrc/hl7

# Makes Mesa's domain library and installs the header files
# into mesa/include

include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

LIB = libhl7.a

#	MHL7Acceptor 
#	MHL7Messenger
#	MHL7Handler
#	MHL7LLPHandler

CLASS_FILES =  \
	MHL7Dispatcher \
	MHL7Factory  \
	MHL7MessageControlID \
	MHL7Msg \
	MHL7Compare \
	MHL7ProtocolHandlerLLP \
	MHL7Reactor \
	MHL7Validator

OBJS = $(CLASS_FILES:=.o)
HEADERS = $(CLASS_FILES:=.hpp)

# Targets

$(LIB): $(OBJS)
	ar cvr $(LIB) $(OBJS)

install:	$(LIB)
	cp $(LIB) $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
#-------Copy		   Source	Destination

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	cp *.html $(MESA_CLASS_DOCS)/hl7

clean:
	rm -rf Template.DB $(LIB) $(OBJS) *.html *~

headerexport:
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
