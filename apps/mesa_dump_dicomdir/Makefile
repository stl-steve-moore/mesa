include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_dump_dicomdir

app:	$(APPS)

OBJS = mesa_dump_dicomdir.o

mesa_dump_dicomdir:	$(OBJS)
	$(CXX) -o mesa_dump_dicomdir $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_dump_dicomdir $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

relink:
	$(CXX) -o mesa_dump_dicomdir $(OBJS) $(L_FLAGS) $(LIBS_MESA)


