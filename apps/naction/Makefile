include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = naction

app:	$(APPS)

OBJS = naction.o naction_support.o MLNAction.o

naction:	$(OBJS)
	$(CXX) -o naction $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) naction $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i sc.txt sc.dcm
test:
	./naction -i 1 localhost 2350 commit sc.dcm 1.2.3.4
