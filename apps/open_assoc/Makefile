include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = open_assoc

app:	$(APPS)

OBJS = open_assoc.o

open_assoc:	$(OBJS)
	$(CXX) -o open_assoc $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) open_assoc $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~


test:
	./open_assoc -f broad_query.dcm 2350
