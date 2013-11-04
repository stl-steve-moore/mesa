include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	txt_to_hl7

install:	app
	$(INSTALL) txt_to_hl7 $(MESA_BIN)

txt_to_hl7:	txt_to_hl7.o
	$(CXX) -o txt_to_hl7 txt_to_hl7.o $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o txt_to_hl7 txt_to_hl7.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf txt_to_hl7 core *.o

t1:	txt_to_hl7
	./txt_to_hl7 -b /opt/mesa/runtime -d ihe-iti -f a28.txt > a28.hl7

