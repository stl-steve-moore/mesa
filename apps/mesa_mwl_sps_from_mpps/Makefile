# Makefile for apps/mesa_mwl_sps_from_mpps

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = mesa_mwl_sps_from_mpps
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

t1:	$(BIN)
	./$(BIN) -u "CATH.001^Cardiac_Cath_Consultation^ERL_MESA" ordfil X1_A1 mpps.status
