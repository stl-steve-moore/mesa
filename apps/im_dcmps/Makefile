include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = im_dcmps

app:	$(APPS)

OBJS = im_dcmps.o sscond.o MLMPPS.o MLMove.o MLQuery.o MLStorage.o MLStorageCommitment.o

im_dcmps:	$(OBJS)
	$(CXX) -o im_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o im_dcmps $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) im_dcmps $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

run:
	./im_dcmps 2350
