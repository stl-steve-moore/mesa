include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = domainobjs patient visit requestedprocedure sps mpps series orderplacer ids uids

app:	$(APPS)

ids:	ids.o
	$(CXX) -o ids ids.o $(L_FLAGS) $(LIBS_MESA)

domainobjs:	domainobjs.o
	$(CXX) -o domainobjs domainobjs.o $(L_FLAGS) $(LIBS_MESA)

patient:	patient.o
	$(CXX) -o patient patient.o $(L_FLAGS) $(LIBS_MESA)

visit:	visit.o
	$(CXX) -o visit visit.o $(L_FLAGS) $(LIBS_MESA)

requestedprocedure:	requestedprocedure.o
	$(CXX) -o requestedprocedure requestedprocedure.o $(L_FLAGS) $(LIBS_MESA)

sps:	sps.o
	$(CXX) -o sps sps.o $(L_FLAGS) $(LIBS_MESA)

mpps:	mpps.o
	$(CXX) -o mpps mpps.o $(L_FLAGS) $(LIBS_MESA)

series:	series.o
	$(CXX) -o series series.o $(L_FLAGS) $(LIBS_MESA)

orderplacer:	orderplacer.o
	$(CXX) -o orderplacer orderplacer.o $(L_FLAGS) $(LIBS_MESA)

uids:	uids.o
	$(CXX) -o uids uids.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf $(APPS) core *.o
