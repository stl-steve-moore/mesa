include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cecho

app:	$(APPS)

OBJS = cecho.o

cecho:	$(OBJS)
	$(CXX) -o cecho $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

install:	$(APPS)
	$(INSTALL) cecho $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

relink:
	$(CXX) -o cecho $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

t1:
	./cecho -l 4 -a A -c B localhost 2100

