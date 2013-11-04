include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	hl7_to_txt

install:	app
	$(INSTALL) hl7_to_txt $(MESA_BIN)

hl7_to_txt:	hl7_to_txt.o
	$(CXX) -o hl7_to_txt hl7_to_txt.o $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o hl7_to_txt hl7_to_txt.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf hl7_to_txt core *.o
