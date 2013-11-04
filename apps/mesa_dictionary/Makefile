include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_dictionary  

app:	$(APPS)

OBJS = mesa_dictionary.o

mesa_dictionary:	$(OBJS)
	$(CXX) -o mesa_dictionary $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_dictionary $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:

test:
