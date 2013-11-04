include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = ds_dcm

app:	$(APPS)

OBJS = ds_dcm.o sscond.o MLMPPS.o MLMove.o MLQuery.o MLStorage.o MLStorageCommitment.o MLStorageCommitmentSCU.o MLGPPPS.o

ds_dcm:	$(OBJS)
	$(CXX) -o ds_dcm $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o ds_dcm $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) ds_dcm $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

run:	ds_dcm
	./ds_dcm -l 4 ../../runtime/imgmgr/ds_dcm.cfg

run-j:
	./ds_dcm ../../runtime/imgmgr/ds_dcm_japanese.cfg

study_root:	ds_dcm
	./ds_dcm ../../runtime/imgmgr_study/ds_dcm.cfg

wkstation:	ds_dcm
	./ds_dcm ../../runtime/wkstation/ds_dcm_gsps.cfg
