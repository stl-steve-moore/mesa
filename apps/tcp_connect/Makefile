# apps/send_hl7

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = tcp_connect
#FILES = MLMessenger
OBJS = $(BIN:=.o) $(FILES:=.o)

L_FLAGS = $(L_OPTS)

$(BIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o $(BIN) $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

clean:
	rm -rf $(BIN) *.o *~ *.bak *.rpo core Template.DB
