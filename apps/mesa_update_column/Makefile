include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_update_column

app:	$(APPS)

OBJS = mesa_update_column.o 

mesa_update_column:	$(OBJS)
	$(CXX) -o mesa_update_column $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_update_column $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_update_column $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

test:	mesa_update_column
