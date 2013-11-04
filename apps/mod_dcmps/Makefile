include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mod_dcmps

app:	$(APPS)

OBJS = mod_dcmps.o sscond.o MLStorageCommitment.o

mod_dcmps:	$(OBJS)
	$(CXX) -o mod_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mod_dcmps $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
