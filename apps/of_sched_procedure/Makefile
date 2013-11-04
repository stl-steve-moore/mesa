# Makefile for apps/of_sched_procedure

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = of_sched_procedure
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
