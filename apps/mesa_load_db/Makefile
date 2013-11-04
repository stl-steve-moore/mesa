include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_load_db

app:	$(APPS)

OBJS = mesa_load_db.o 

mesa_load_db:	$(OBJS)
	$(CXX) -o mesa_load_db $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_load_db $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_load_db $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	mesa_load_db
	./mesa_load_db ordfil codes_of.txt

t2:	mesa_load_db
	./mesa_load_db imgmgr demog.txt
