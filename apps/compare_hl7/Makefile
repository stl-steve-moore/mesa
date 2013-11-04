# Makefile for apps/op_hl7ps

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = compare_hl7
FILES = compare_hl7

L_FLAGS = $(L_OPTS)

$(BIN): $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $@ $(FILES:=.o) $(L_FLAGS) $(LIBS_MESA)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

relink: $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $(BIN) $+ $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)

t2:
	./compare_hl7 -m y/adt_a06_compare.ini y/101.126.a06.hl7 y/1002.hl7
