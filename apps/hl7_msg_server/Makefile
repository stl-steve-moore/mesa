include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)


BIN = hl7_msg_server
FILES =  MMessageCollector MHL7IDXFactory
OBJS = $(BIN:=.o) $(FILES:=.o)

L_FLAGS = $(L_OPTS)

$(BIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(L_FLAGS) $(LIBS_MESA_MAILER) 

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

relink:
	$(CXX) -o $(BIN) $(OBJS) $(L_FLAGS) $(LIBS_MESA_MAILER)

clean:
	rm -rf *.o *~ *.bak *.rpo core $(BIN)



