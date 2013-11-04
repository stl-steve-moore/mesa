include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = dcm_get_elements

app:	$(APPS)

OBJS = dcm_get_elements.o

dcm_get_elements:	$(OBJS)
	$(CXX) -o dcm_get_elements $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) dcm_get_elements $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:

test:
	./dcm_get_elements sr.dcm
	./dcm_get_elements -s sr.dcm
	./dcm_get_elements -e 0040.a730:1 sr.dcm
	./dcm_get_elements -e 0040.a730:1,0040.a043:1,0008.0104 sr.dcm
