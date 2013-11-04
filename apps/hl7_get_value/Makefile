include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	hl7_get_value

install:	app
	$(INSTALL) hl7_get_value $(MESA_BIN)

hl7_get_value:	hl7_get_value.o
	$(CXX) -o hl7_get_value hl7_get_value.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf hl7_get_value core *.o

t1:	hl7_get_value
	./hl7_get_value -f a28.hl7 -d ihe-iti PID 3 1
