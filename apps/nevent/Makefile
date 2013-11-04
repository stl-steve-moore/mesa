include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = nevent

app:	$(APPS)

OBJS = nevent.o MLNEventReport.o

nevent:	$(OBJS)
	$(CXX) -o nevent $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) nevent $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i sc.txt sc.dcm
test:
	./nevent -i 1 localhost 2100 commit sc.dcm 1.2.3.4
