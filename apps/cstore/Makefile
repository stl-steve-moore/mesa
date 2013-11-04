include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cstore

app:	$(APPS)

OBJS = cstore.o cstore_support.o MLCStore.o

cstore:	$(OBJS)
	$(CXX) -o cstore $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

install:	$(APPS)
	$(INSTALL) cstore $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

relink:
	$(CXX) -o cstore $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)
