include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = dcm_print_element

app:	$(APPS)

OBJS = dcm_print_element.o

dcm_print_element:	$(OBJS)
	$(CXX) -o dcm_print_element $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) dcm_print_element $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:

test:
	./dcm_print_element 0040 0252 pps.dcm
	./dcm_print_element -s 0008 1199 0008 1155 a.dcm
	./dcm_print_element -i 2 -s 0008 1199 0008 1155 a.dcm
	./dcm_print_element -i 3 -s 0008 1199 0008 1155 a.dcm

t1:
	./dcm_print_element -z 0040 A370 0008 1110 0008 1155 gppps.dcm

t2:
	./dcm_print_element -z 0040 4035 0040 4009 0008 0100 gppps.dcm

t3:	dcm_print_element
	./dcm_print_element -x -s 0008 1032 0008 0100 mpps.status
	./dcm_print_element -x -s 0008 1032 0008 0101 mpps.status
	./dcm_print_element -x  0008 1032 mpps.status
	./dcm_print_element -x -s 0040  0340 0008 1070 mpps.status
	./dcm_print_element -x 0040 0340 mpps.crt
