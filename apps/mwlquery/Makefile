include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mwlquery

app:	$(APPS)

OBJS = mwlquery.o mwlquery_support.o MLQuery.o

mwlquery:	$(OBJS)
	$(CXX) -o mwlquery $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mwlquery $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i q1.txt q1.dcm
	dcm_create_object -i q2.txt q2.dcm
	dcm_create_object -i q3.txt q3.dcm
	dcm_create_object -i q4.txt q4.dcm
	dcm_create_object -i q5.txt q5.dcm
	dcm_create_object -i q6.txt q6.dcm
	dcm_create_object -i q7.txt q7.dcm
	dcm_create_object -i q8.txt q8.dcm
	dcm_create_object -i q9.txt q9.dcm
	dcm_create_object -i broad_query.txt broad_query.dcm
#	dcm_create_object -i broad_query2.txt broad_query2.dcm

test:
	./mwlquery -f broad_query.dcm localhost 2250

q1:
	./mwlquery -f q1.dcm localhost 2250

q2:
	./mwlquery -f q2.dcm localhost 2250

q3:
	./mwlquery -f q3.dcm localhost 2250

q4:
	./mwlquery -f q4.dcm localhost 2250

q5:
	./mwlquery -f q5.dcm localhost 2250

q6:
	./mwlquery -f q6.dcm localhost 2250

q7:
	./mwlquery -f q7.dcm localhost 2250

q8:
	./mwlquery -f q8.dcm localhost 2250

q9:
	./mwlquery -f q9.dcm localhost 2250
