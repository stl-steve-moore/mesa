# File: Makefile
# Directory: perdita:/mesa/apps
# 5/25/99

include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

BIN = adt_ps
FILES = MLMessenger

#MESA_L_FLAGS = -L$(MESA_LIB) -L$(CTN_LIB) -L$(PSQL_ROOT)/lib
#ACE_L_FLAGS = -L. -L$(ACE_ROOT)/ace 


# Targets

$(BIN): $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $@ $+ $(L_FLAGS) $(LIBS_MESA)
#	$(CXX) $(C_FLAGS) $(INCLUDES) -o $@ $+ $(MESA_L_FLAGS) $(ACE_L_FLAGS) $(MESA_LIBS) $(ACE_LIBS)

relink: $(BIN:=.o) $(FILES:=.o)
	$(CXX) $(C_FLAGS) $(INCLUDES) -o $(BIN) $+ $(MESA_L_FLAGS) $(ACE_L_FLAGS) $(MESA_LIBS) $(ACE_LIBS)

clean:
	rm -rf *.o *~ *.bak *.rpo core
