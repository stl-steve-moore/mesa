include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mpps_add_perf_series

app:	$(APPS)

OBJS = mpps_add_perf_series.o

mpps_add_perf_series:	$(OBJS)
	$(CXX) -o mpps_add_perf_series $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mpps_add_perf_series $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
test:
	dcm_create_object -i pps.txt pps.dcm
	./mpps_add_perf_series pps.dcm x1.dcm x2.dcm
