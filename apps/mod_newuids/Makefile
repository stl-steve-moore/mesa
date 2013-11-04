include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mod_newuids

app:	$(APPS)

OBJS = mod_newuids.o

mod_newuids:	$(OBJS)
	$(CXX) -o mod_newuids $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mod_newuids $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~
test:
	cp MR8S1IM1.dcm a.dcm
	cp MR8S1IM1.dcm b.dcm
	./mod_newuids a.dcm b.dcm
