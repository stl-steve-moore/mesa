include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = dcm_ref_sop_seq

app:	$(APPS)

OBJS = dcm_ref_sop_seq.o

dcm_ref_sop_seq:	$(OBJS)
	$(CXX) -o dcm_ref_sop_seq $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) dcm_ref_sop_seq $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
test:
