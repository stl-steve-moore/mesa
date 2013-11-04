# Makefile for apps/op_hl7ps

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = im_hl7ps
FILES = \
	MLMessenger
#	MAMessenger
OBJS = $(BIN:=.o) $(FILES:=.o)

L_FLAGS = $(L_OPTS)

$(BIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(L_FLAGS) $(LIBS_MESA) $(LIBS_ACE)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

relink:
	$(CXX) -o $(BIN) $(OBJS) $(L_FLAGS) $(LIBS_MESA) $(LIBS_ACE)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)

run:
	./im_hl7ps -a -z imgmgr 2300

analysis:
	./im_hl7ps -a 2300
