include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = nset

app:	$(APPS)

OBJS = nset.o nset_support.o MLNSet.o

nset:	$(OBJS)
	$(CXX) -o nset $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) nset $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i pps.txt pps.dcm
test:
	./nset localhost 2350 mpps pps.dcm 1.2.3
