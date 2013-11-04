# Makefile for apps/mesa_mwl_add_sps

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = mesa_mwl_add_sps
FILES = 
OBJS = $(BIN:=.o) $(FILES:=.o)

L_FLAGS = $(L_OPTS)


$(BIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

relink:
	$(CXX) -o $(BIN) $(OBJS) $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)
