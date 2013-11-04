
install:
	cp ecg.html $(TOMCAT_HOME)/webapps/ROOT
	cp rid.html $(TOMCAT_HOME)/webapps/ROOT
	cp svs.html $(TOMCAT_HOME)/webapps/ROOT
	cp IHEDocumentList.xsl $(TOMCAT_HOME)/webapps/ROOT
	cp web_unix_postgresql.xml $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/web.xml
	rm -f mesaweb_rid.jar
	$(MAKE) mesaweb_rid.jar
#	$(MESA_ROOT)/scripts/createdirectory $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
#	$(INSTALL) mesaweb_rid.jar $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
	$(INSTALL) mesaweb_rid.jar $(TOMCAT_HOME)/common/lib
	$(MESA_ROOT)/scripts/createdirectory $(MESA_TARGET)/webmesa
	$(MESA_ROOT)/scripts/createdirectory $(MESA_TARGET)/webmesa/mesa-iti
	cp ecg.html $(MESA_TARGET)/webmesa/mesa-iti
	cp rid.html $(MESA_TARGET)/webmesa/mesa-iti
	cp svs.html $(MESA_TARGET)/webmesa/mesa-iti
	cp IHEDocumentList.xsl $(MESA_TARGET)/webmesa/mesa-iti
	cp web_unix_postgresql.xml $(MESA_TARGET)/webmesa/mesa-iti
	$(INSTALL) mesaweb_rid.jar $(MESA_TARGET)/webmesa/mesa-iti
	$(INSTALL) Makefile.iti $(MESA_TARGET)/webmesa/mesa-iti
	$(INSTALL) postgresql.jar $(MESA_TARGET)/webmesa/mesa-iti

install_rid_view:
	rm -f mesaweb_rid.jar
	$(MAKE) mesaweb_rid.jar
	$(MESA_TARGET)/bin/createdirectory $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
	$(INSTALL) mesaweb_rid.jar $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib

all:	install install_rid_view

C = edu/wustl/mir/mesaweb/common
R = edu/wustl/mir/mesaweb/rid
S = edu/wustl/mir/mesaweb/svs
mesaweb_rid.jar:
	cd edu/wustl/mir/mesaweb/common; make
	cd edu/wustl/mir/mesaweb/rid; make
	cd edu/wustl/mir/mesaweb/svs; make
	$(JDK_ROOT)/bin/jar -c0vf mesaweb_rid.jar $(C)/*.class $(R)/*.class $(S)/*.class

clean:
	cd edu/wustl/mir/mesaweb/rid; make clean

docs:
	cd edu/wustl/mir/mesaweb/rid; $(MAKE) docs

