include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = simple_storage

app:	$(APPS)

OBJS = simple_storage.o sscond.o MLStorage.o

simple_storage:	$(OBJS)
	$(CXX) -o simple_storage $(OBJS) $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf $(APPS) core *.o
