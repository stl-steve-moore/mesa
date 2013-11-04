# Makefile for apps/op_send

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = op_send
FILES = \
	MLMessenger
#       MAMessenger
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
