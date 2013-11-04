include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)


BIN = hl7_rcvr
FILES = MLDispatchChargeProcessor MLDispatchImgMgr MLDispatchImgMgrJapanese \
MLDispatchOrderFiller MLDispatchOrderFillerJapanese MLDispatchOrderPlacer \
MLDispatchOrderPlacerJapanese MLDispatchReportMgr MLDispatchReportMgrJapanese \
MLDispatchPDSupplier MLDispatchXRefMgr

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
	./hl7_rcvr -d ihe-iti -M PDS -a -z pd_supplier 3700

test-mem:	$(BIN)
#	valgrind --tool=memcheck --leak-check=yes --trace-children=yes --leak-check=full --show-reachable=yes hl7_rcvr  -a -z ordfil -M OF 2200
	valgrind --tool=memcheck --leak-check=yes --trace-children=yes --leak-check=full  ./hl7_rcvr  -a -z ordfil -M OF 2200

t2:	$(BIN)
	./hl7_rcvr -d ihe-iti -M OF -a -z ordfil 2200
