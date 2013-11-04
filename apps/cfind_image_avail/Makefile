include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cfind_image_avail

app:	$(APPS)

OBJS = cfind_image_avail.o MLQuery.o

cfind_image_avail:	$(OBJS)
	$(CXX) -o cfind_image_avail $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cfind_image_avail $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
	dcm_create_object -i q1.txt q1.dcm

t1:
	./cfind_image_avail localhost 2350 mpps.status
