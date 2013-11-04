include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	hl7 hl7_ack hl7_b hl7_c hl7_d hl7_patient hl7_placerorder hl7_visit
#app:	hl7 hl7_a hl7_b hl7_c hl7_d hl7_patient hl7_visit

hl7:	hl7.o
	$(CXX) -o hl7 hl7.o $(L_FLAGS) $(LIBS_MESA)

hl7_a:	hl7_a.o
	$(CXX) -o hl7_a hl7_a.o $(L_FLAGS) $(LIBS_MESA)

hl7_ack:	hl7_ack.o
	$(CXX) -o hl7_ack hl7_ack.o $(L_FLAGS) $(LIBS_MESA)

hl7_b:	hl7_b.o
	$(CXX) -o hl7_b hl7_b.o $(L_FLAGS) $(LIBS_MESA)

hl7_c:	hl7_c.o
	$(CXX) -o hl7_c hl7_c.o $(L_FLAGS) $(LIBS_MESA)

hl7_d:	hl7_d.o
	$(CXX) -o hl7_d hl7_d.o $(L_FLAGS) $(LIBS_MESA)

hl7_placerorder:	hl7_placerorder.o
	$(CXX) -o hl7_placerorder hl7_placerorder.o $(L_FLAGS) $(LIBS_MESA)

hl7_patient:	hl7_patient.o
	$(CXX) -o hl7_patient hl7_patient.o $(L_FLAGS) $(LIBS_MESA)

hl7_visit:	hl7_visit.o
	$(CXX) -o hl7_visit hl7_visit.o $(L_FLAGS) $(LIBS_MESA)

hl7_compare:	hl7_compare.o
	$(CXX) -o hl7_compare hl7_compare.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf hl7 hl7_a hl7_ack hl7_b hl7_c hl7_d hl7_placerorder core *.o
