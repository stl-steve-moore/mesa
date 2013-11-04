include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mpps_construct

app:	$(APPS)

OBJS = mpps_construct.o

mpps_construct:	$(OBJS)
	$(CXX) -o mpps_construct $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mpps_construct $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
test:
	./mpps_construct -p xxx x1.dcm
	dcm_create_object -i ssas.txt ssas.dcm
	dcm_create_object -i pps.txt pps.dcm
	./mpps_construct -s 0040 0270 x1.dcm ssas.dcm x3.dcm
	./mpps_construct x3.dcm pps.dcm x4.dcm
