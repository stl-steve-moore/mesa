include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = sc_scp_association

app:	$(APPS)

OBJS = sc_scp_association.o

sc_scp_association:	$(OBJS)
	$(CXX) -o sc_scp_association $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) sc_scp_association $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i sc.txt sc.dcm
test:
	./sc_scp_association -i 1 localhost 2350 commit sc.dcm 1.2.3.4
