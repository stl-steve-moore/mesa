# Makefile for apps/hl7_evaluate

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = hl7_evaluate
FILES = hl7_evaluate

L_FLAGS = $(L_OPTS)

$(BIN): $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $@ $(FILES:=.o) $(L_FLAGS) $(LIBS_MESA)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

relink: $(FILES:=.o)
	$(CXX) -o $(BIN) $+ $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)

test:
	./hl7_evaluate -m hl7_v.ini a04.hl7

test_v:
	./hl7_evaluate -v -m hl7_v.ini a04.hl7

data:
	txt_to_hl7 < a04.txt > a04.hl7

t2:
	./hl7_evaluate -v -m x/a04.ini x/1001.hl7

t3:
	./hl7_evaluate -m y/a06.ini y/1002.hl7

t4:
	./hl7_evaluate -m a/a40.ini a/1005.hl7
