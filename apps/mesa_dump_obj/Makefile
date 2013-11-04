include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_dump_obj

app:	$(APPS)

OBJS = mesa_dump_obj.o

mesa_dump_obj:	$(OBJS)
	$(CXX) -o mesa_dump_obj $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

install:	$(APPS)
	$(INSTALL) mesa_dump_obj $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
