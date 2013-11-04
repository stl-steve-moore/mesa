include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mpps_evaluate

app:	$(APPS)

OBJS = mpps_evaluate.o MLMPPSEvaluator.o MLEvalSimple1.o MLEvalUnscheduled2.o \
MLEvalGroup3.o

mpps_evaluate:	$(OBJS)
	$(CXX) -o mpps_evaluate $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

install:	$(APPS)
	$(INSTALL) mpps_evaluate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

test1:
	./mpps_evaluate -v mod 1 mpps.status mpps.status

test1a:
	./mpps_evaluate -v mod 1 mpps_p1.status mpps_p2.status
