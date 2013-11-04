include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = im_sc_agent im_sc_filldb im_sc_check

app:	$(APPS)

OBJS = im_sc_agent.o

im_sc_agent:	$(OBJS)
	$(CXX) -o im_sc_agent $(OBJS) $(L_FLAGS) $(LIBS_MESA)

im_sc_filldb:	im_sc_filldb.o
	$(CXX) -o im_sc_filldb im_sc_filldb.o $(L_FLAGS) $(LIBS_MESA)

im_sc_check:	im_sc_check.o
	$(CXX) -o im_sc_check im_sc_check.o $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) im_sc_agent $(MESA_BIN)
	$(INSTALL) im_sc_filldb $(MESA_BIN)
	$(INSTALL) im_sc_check $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
test:
	./im_sc_agent -c MODALITY1 sc.dcm
t1:
	./im_sc_filldb ../im_dcmps/imgmgr/st_comm/MODALITY/*opn
