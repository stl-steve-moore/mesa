include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = export_agent

app:	$(APPS)

OBJS = export_agent.o MLQuery.o MLXferAgent.o

export_agent:	$(OBJS)
	$(CXX) -o export_agent $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o export_agent $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) export_agent $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./export_agent xyz


t2:
	./export_agent -d -l 3 imgmgr_study

t3:
	./export_agent -l 3 imgmgr_study
