include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = syslog_client

app:	$(APPS)

all:	syslog_client syslog_client_secure

syslog_client:	syslog_client.o
	$(CXX) -g -o syslog_client syslog_client.o $(L_FLAGS) -lsyslog $(LIBS_MESA)

syslog_client_secure:	syslog_client_secure.o
	$(CXX) -g -o syslog_client_secure syslog_client_secure.o $(L_FLAGS) -lsyslog $(LIBS_MESA_SSL)

syslog_client_secure.o: syslog_client.cpp
	$(CXX) -o syslog_client_secure.o -DRFC5425 $(CXX_FLAGS) $(INCLUDES) -c syslog_client.cpp


relink:
	$(CXX) -o syslog_client syslog_client.o $(L_FLAGS) -lsyslog $(LIBS_MESA)

C = $(MESA_TARGET)/runtime/certs-ca-signed/test_sys_1.cert.pem
K = $(MESA_TARGET)/runtime/certs-ca-signed/test_sys_1.key.pem
P = $(MESA_TARGET)/runtime/certs-ca-signed/mesa_list.cert
R = $(MESA_TARGET)/runtime/certs-ca-signed/randoms.dat

install:	$(APPS)
	$(INSTALL) syslog_client $(MESA_BIN)

install_all:	all
	$(INSTALL) syslog_client $(MESA_BIN)
	$(INSTALL) syslog_client_secure $(MESA_BIN)

install_secure:	syslog_client_secure
	$(INSTALL) syslog_client_secure $(MESA_BIN)

clean:
	rm -rf $(APPS) syslog_client_secure core *.o

t1:	syslog_client
	./syslog_client -f 10 -s 0 localhost 4000 startup.xml

t2:	syslog_client
	./syslog_client -m 1 -f 10 -s 0 localhost 4000 startup.xml

t3:	syslog_client
	./syslog_client -m 1 -f 10 -s 0 localhost 4000 syslog.txt

t101:	syslog_client
	./syslog_client -c -r 5424 -m 1 localhost 4000 "<xml>payload</xml>"

t102:	syslog_client
	./syslog_client -c -r 5424 -x TCP -m 1 localhost 4000 "<xml>payload</xml>"

t103:	syslog_client_secure
	./syslog_client_secure -j NA2010 -l 4 -C $(C) -K $(K) -P $(P) -R $(R) -c -r 5424 -x 5425 -m 1 localhost 4000 "<xml>payload</xml>"

t104:	syslog_client
	./syslog_client -c -r 5424 -x 5426 -m 1 localhost 4001 "<xml>payload</xml>"


nextgen2:	syslog_client
	./syslog_client -f 5 -s 4 nextgen2 514 x1.xml
