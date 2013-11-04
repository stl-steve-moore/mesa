include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = syslog_server
APPS_SECURE = syslog_server_secure

app:	$(APPS)

syslog_server:	syslog_server.o
	$(CXX) -o syslog_server syslog_server.o $(L_FLAGS) $(LIBS_MESA)

syslog_server_secure:	syslog_server_secure.o
	$(CXX) -o syslog_server_secure syslog_server_secure.o $(L_FLAGS) $(LIBS_MESA_SSL)

syslog_server_secure.o:	syslog_server.cpp
	$(CXX) -o syslog_server_secure.o -DRFC5425 $(CXX_FLAGS) $(INCLUDES) -c syslog_server.cpp


relink:
	$(CXX) -o syslog_server syslog_server.o $(L_FLAGS) $(LIBS_MESA_SSL)

install:	$(APPS)
	$(INSTALL) syslog_server $(MESA_BIN)

install_secure:	$(APPS_SECURE)
	$(INSTALL) syslog_server_secure $(MESA_BIN)

C = $(MESA_TARGET)/runtime/certs-ca-signed/mesa_1.cert.pem
K = $(MESA_TARGET)/runtime/certs-ca-signed/mesa_1.key.pem
P = $(MESA_TARGET)/runtime/certs-ca-signed/test_list.cert
R = $(MESA_TARGET)/runtime/certs-ca-signed/randoms.dat

clean:
	rm -rf $(APPS) $(APPS_SECURE) core *.o *.?pp~

t1:	syslog_server
	./syslog_server 4000

t2:	syslog_server
	./syslog_server -l 4 -r 5424 4000

t102:	syslog_server
	./syslog_server -l 4 -r 5424 -x TCP 4000

t103:	syslog_server_secure
	./syslog_server_secure -l 4 -r 5424 -x 5425 -C $(C) -K $(K) -P $(P) -R $(R) 4000

t104:	syslog_server
	./syslog_server -l 4 -r 5424 -x 5426 4001

t200:	syslog_server
	./syslog_server -f syslog-payload.txt
	./syslog_server -f x1-payload.txt
	./syslog_server -f x2-payload.txt
	./syslog_server -f x3-payload.txt
	./syslog_server -f x4-payload.txt
	./syslog_server -f x5-payload.txt
	./syslog_server -f x6-payload.txt
	./syslog_server -f x7-payload.txt
