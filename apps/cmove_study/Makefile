include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cmove_study

app:	$(APPS)

OBJS = cmove_study.o MLQuery.o MLMove.o

cmove_study:	$(OBJS)
	$(CXX) -o cmove_study $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cmove_study $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
	dcm_create_object -i q1.txt q1.dcm

q1:
	./cmove_study -x STUDY -f q1.dcm localhost 2350
