include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mpps_ncreate

app:	$(APPS)

OBJS = mpps_ncreate.o MLNCreate.o

mpps_ncreate:	$(OBJS)
	$(CXX) -o mpps_ncreate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mpps_ncreate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
test:
	./mpps_ncreate localhost 2100 x4.dcm 1.2.3
