include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_strip_file

app:	$(APPS)

OBJS = mesa_strip_file.o

mesa_strip_file:	$(OBJS)
	$(CXX) -o mesa_strip_file $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_strip_file $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_strip_file $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	mesa_strip_file
	./mesa_strip_file -l 4 -r retain_ct.txt ct.dcm ct_out.dcm
