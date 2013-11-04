include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mpps_merge 

app:	$(APPS)

OBJS = mpps_merge.o

mpps_merge:	$(OBJS)
	$(CXX) -o mpps_merge $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mpps_merge $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
