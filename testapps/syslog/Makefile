include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = syslog_test

app:	$(APPS)

syslog_test:	syslog_test.o
	$(CXX) -o syslog_test syslog_test.o $(L_FLAGS) -lsyslog $(LIBS_MESA)

relink:
	$(CXX) -o syslog_test syslog_test.o $(L_FLAGS) -lsyslog $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) syslog_test $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o

t0:	syslog_test
	./syslog_test 0

t1:	syslog_test
	./syslog_test 1

t2:	syslog_test
	./syslog_test 2 > ihe_syslog_2.txt; sleep 2

t3:	syslog_test
	./syslog_test 3 > ihe_syslog_3.txt; sleep 2

t4:	syslog_test
	./syslog_test 4 > ihe_syslog_4.txt; sleep 2

zip:	t2 t3 t4
	zip ihe_syslog.zip ihe_syslog_2.txt ihe_syslog_3.txt ihe_syslog_4.txt readme.txt


