include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cfind_resp_evaluate

app:	$(APPS)

OBJS = cfind_resp_evaluate.o

cfind_resp_evaluate:	$(OBJS)
	$(CXX) -o cfind_resp_evaluate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o cfind_resp_evaluate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cfind_resp_evaluate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./cfind_resp_evaluate -v 0008 0018 xyz ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_pre ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_post

t2:
	./cfind_resp_evaluate 0008 0018 xyz ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_post ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_post
	
t3:
	./cfind_resp_evaluate -v 0008 0018 xyz ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_post ../../testdata/y3_actor/actors/imgmgr/101/ia_x1_post
	
