include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = sc_scu_association

app:	$(APPS)

OBJS = sc_scu_association.o

sc_scu_association:	$(OBJS)
	$(CXX) -o sc_scu_association $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) sc_scu_association $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i sc.txt sc.dcm
test:
	./sc_scu_association -i 1 localhost 2350 commit sc.dcm 1.2.3.4
