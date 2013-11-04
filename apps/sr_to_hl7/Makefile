include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	sr_to_hl7

install:	app
	$(INSTALL) sr_to_hl7 $(MESA_BIN)

sr_to_hl7:	sr_to_hl7.o
	$(CXX) -o sr_to_hl7 sr_to_hl7.o $(L_FLAGS) $(LIBS_MESA)

relink:	
	$(CXX) -o sr_to_hl7 sr_to_hl7.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf sr_to_hl7 core *.o

t603:
	./sr_to_hl7 -t msh.txt ../../testdata/y3_actor/msgs/sr/603/sr_603mr.dcm x.hl7
