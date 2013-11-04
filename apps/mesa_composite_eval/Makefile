include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_composite_eval

app:	$(APPS)

OBJS = mesa_composite_eval.o

mesa_composite_eval:	$(OBJS)
	$(CXX) -o mesa_composite_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_composite_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_composite_eval $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./mesa_composite_eval -o mwl -p x1.dcm x1.dcm

t1v:
	./mesa_composite_eval -v -o mwl -p x1.dcm x1.dcm


t2:
	./mesa_composite_eval -o mwl -p x2.dcm 2224.dcm

t2v:
	./mesa_composite_eval -v -o mwl -p x2.dcm 2224.dcm
