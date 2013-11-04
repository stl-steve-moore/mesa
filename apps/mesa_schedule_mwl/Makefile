# Makefile for apps/mesa_schedule_mwl

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = mesa_schedule_mwl
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

test:	mesa_schedule_mwl
	./mesa_schedule_mwl -c plaordnum A132Z^MESA_ORDPLC -m CT -t XYZ ordfil
