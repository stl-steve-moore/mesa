include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = cfind_evaluate

app:	$(APPS)

OBJS = cfind_evaluate.o MLCFindEval.o MLEvalImageAvail.o MLEvalMWL.o MLEvalStudy.o

cfind_evaluate:	$(OBJS)
	$(CXX) -o cfind_evaluate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) cfind_evaluate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i broad_query.txt broad_query.dcm
	dcm_create_object -i q1.txt q1.dcm

t1:
	./cfind_evaluate -v STUDY study_1.qry

t2:
	./cfind_evaluate -v IMG_AVAIL study_1.qry
