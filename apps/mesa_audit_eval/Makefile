include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_audit_eval

app:	$(APPS)

OBJS = mesa_audit_eval.o

mesa_audit_eval:	$(OBJS)
	$(CXX) -o mesa_audit_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_audit_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_audit_eval $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	mesa_audit_eval
	./mesa_audit_eval -t STARTUP last_log.txt
