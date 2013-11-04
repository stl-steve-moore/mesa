include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	hl7_set_value

install:	app
	$(INSTALL) hl7_set_value $(MESA_BIN)

hl7_set_value:	hl7_set_value.o
	$(CXX) -o hl7_set_value hl7_set_value.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf hl7_set_value core *.o
