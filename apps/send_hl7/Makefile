# apps/send_hl7

include $(MESA_MAKE)

CXX_FLAGS = $(C_OPTS)

BIN = send_hl7
FILES = MLDispatch MLDispatchQuery MLDispatchQueryContinue
OBJS = $(BIN:=.o) $(FILES:=.o)

L_FLAGS = $(L_OPTS)

$(BIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o $(BIN) $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(BIN)
	$(INSTALL) $(BIN) $(MESA_BIN)

clean:
	rm -rf $(BIN) *.o *~ *.bak *.rpo core Template.DB

x:	send_hl7
	./send_hl7 localhost 2200 x.hl7

q23:	send_hl7
	rm -f hl7stream.xxx; ./send_hl7 -c -l 4 -d ihe-iti localhost 3600 q23.hl7

q23-110:	send_hl7
	rm -f hl7stream.xxx; ./send_hl7 -c -l 4 -d ihe-iti localhost 3600 q23-110.hl7

qpd:	send_hl7
	rm -f hl7stream.xxx; ./send_hl7 -C xx -Q  -l 4 -d ihe-iti localhost 3700 11311.102.q22.hl7

11300:	send_hl7
	rm -f hl7stream.xxx; ./send_hl7 -C xx -Q  -l 4 -d ihe-iti localhost 3700 11300.hl7

xref:	send_hl7
	rm -f hl7stream.xxx; rm -r xx; mkdir xx; ./send_hl7 -C xx -Q  -l 4 -d ihe-iti localhost 3600 10501.108.q23.hl7

11365:	send_hl7
	rm -f hl7stream.xxx; ./send_hl7 -C xx -Q  -l 4 -d ihe-iti localhost 3700 /tmp/q22.hl7
