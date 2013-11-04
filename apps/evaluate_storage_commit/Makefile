include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = evaluate_storage_commitment

app:	$(APPS)

OBJS = evaluate_storage_commitment.o

evaluate_storage_commitment:	$(OBJS)
	$(CXX) -o evaluate_storage_commitment $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) evaluate_storage_commitment $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:

test:
