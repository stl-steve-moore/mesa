# Makefile for apps/mesa_db_test

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = mesa_db_test
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

C = $(MESA_TARGET)/runtime/certificates/test_sys_1.cert.pem
K = $(MESA_TARGET)/runtime/certificates/test_sys_1.key.pem
P = $(MESA_TARGET)/runtime/certificates/mesa_list.cert
R = $(MESA_TARGET)/runtime/certificates/randoms.dat

run:	mesa_db_test
	./mesa_db_test -l 4
