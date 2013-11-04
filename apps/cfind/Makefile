include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cfind

app:	$(APPS)

OBJS = cfind.o cfind_support.o MLQuery.o

cfind:	$(OBJS)
	$(CXX) -o cfind $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cfind $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
	dcm_create_object -i q1.txt q1.dcm
	dcm_create_object -i q2.txt q2.dcm
	dcm_create_object -i q3.txt q3.dcm

q1:
	./cfind -x STUDY -f q1.dcm localhost 2350

drno:
	./cfind -a DRNO -c DRNO -x STUDY -f q1.dcm drno 2100

q2:
	./cfind -a DRNO -c DRNO -x STUDY -f q2.dcm drno 2100

q3:	data
	./cfind -a DRNO -c DRNO -x STUDY -f q3.dcm drno 2100
