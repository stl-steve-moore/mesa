include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cfind_study_probe

app:	$(APPS)

OBJS = cfind_study_probe.o MLQuery.o

cfind_study_probe:	$(OBJS)
	$(CXX) -o cfind_study_probe $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cfind_study_probe $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
	dcm_create_object -i q1.txt q1.dcm

q1:
	./cfind_study_probe -x STUDY -f q1.dcm localhost 2350
