# File: Makefile
# Directory: perdita:/mesa/apps/orderplacer
# 5/14/99

# Federico David Sacerdoti

# Included makefiles
########################
include $(MESA_MAKE)
########################

CXX_FLAGS = $(C_OPTS)

BIN = OrderPlacer
FILES = MOPMessenger

L_FLAGS = $(L_OPTS)

# Targets
#######################

$(BIN): $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $@ $+ $(L_FLAGS) $(LIBS_MESA) $(LIBS_ACE)

relink: $(BIN:=.o) $(FILES:=.o)
	$(CXX) -o $(BIN) $+ $(L_FLAGS) $(LIBS_MESA) $(LIBS_ACE)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)
