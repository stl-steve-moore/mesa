include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_storage

app:	$(APPS)

OBJS = mesa_storage.o sscond.o MLStorage.o

mesa_storage:	$(OBJS)
	$(CXX) -o mesa_storage $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_storage $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_storage $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

run:	mesa_storage
	./mesa_storage ../../runtime/imgmgr/mesa_storage.cfg
