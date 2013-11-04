include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_select_column

app:	$(APPS)

OBJS = mesa_select_column.o 

mesa_select_column:	$(OBJS)
	$(CXX) -o mesa_select_column $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_select_column $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_select_column $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

test:	mesa_select_column
	./mesa_select_column filnam sopins rpt_manager files.txt
