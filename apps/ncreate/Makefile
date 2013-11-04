include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = ncreate

app:	$(APPS)

OBJS = ncreate.o ncreate_support.o MLNCreate.o

ncreate:	$(OBJS)
	$(CXX) -o ncreate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) ncreate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i ncreate.txt ncreate.dcm
test:
	./ncreate localhost 2350 mpps ncreate.dcm 1.2.3
