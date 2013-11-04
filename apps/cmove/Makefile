include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cmove

app:	$(APPS)

OBJS = cmove.o MLMove.o

cmove:	$(OBJS)
	$(CXX) -o cmove $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cmove $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i q1.txt q1.dcm

q1:
	./cmove -x STUDY -f q1.dcm localhost 2350 WORKSTATION1
