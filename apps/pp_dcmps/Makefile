include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = pp_dcmps 

app:	$(APPS)

OBJS = pp_dcmps.o sscond.o MLQuery.o MLGPSPS.o MLGPPPS.o

pp_dcmps:	$(OBJS)
	$(CXX) -o pp_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o pp_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) pp_dcmps $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./pp_dcmps -a mwl -z q1.dcm

run:
	./pp_dcmps -l 4 2450
