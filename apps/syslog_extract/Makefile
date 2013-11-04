include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = syslog_extract

app:	$(APPS)

syslog_extract:	syslog_extract.o
	$(CXX) -o syslog_extract syslog_extract.o $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o syslog_extract syslog_extract.o $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) syslog_extract $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	syslog_extract
	./syslog_extract 1


t5:	syslog_extract
	./syslog_extract 5
