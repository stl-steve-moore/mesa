include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mod_weld_mwl

app:	$(APPS)

OBJS = mod_weld_mwl.o

mod_weld_mwl:	$(OBJS)
	$(CXX) -o mod_weld_mwl $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mod_weld_mwl $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
data:
	dcm_create_object -i SPSID1.txt SPSID1.dcm

test:
	./mod_weld_mwl SPSID1.dcm MR8S1IM1.dcm a.dcm
