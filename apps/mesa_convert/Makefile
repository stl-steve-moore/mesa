include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_convert

app:	$(APPS)

OBJS = mesa_convert.o

mesa_convert:	$(OBJS)
	$(CXX) -o mesa_convert $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_convert $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

relink:
	$(CXX) -o mesa_convert $(OBJS) $(L_FLAGS) $(LIBS_MESA)


t1:	mesa_convert
	./mesa_convert -i hex -o char xx.dat < xx.txt

