include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = of_dcmps 

app:	$(APPS)

OBJS = of_dcmps.o sscond.o MLGPPPS.o MLQuery.o MLQueryUPS.o MLMPPS.o MLStorageCommitment.o MLIAN.o
OBJS2 = mwlQuery.o sscond.o MLQuery.o

of_dcmps:	$(OBJS)
	$(CXX) -o of_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o of_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) of_dcmps $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./of_dcmps -a mwl -z q1.dcm

t2:
	./of_dcmps -a mwl -z test_query.dcm

run:	of_dcmps
	./of_dcmps -l 4 2250
