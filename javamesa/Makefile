include $(DICOM_MAKE)
CFLAGS = $(C_OPTS)

install:	jar
	$(INSTALL) javamesa.jar $(JAR_DIRECTORY)

all:	java_classes

java_classes:
	cd MESA; make install

clean:
	cd MESA; make clean


jar:	java_classes
	cp ../java_apps/gui/*.class .
	$(JDK_ROOT)/bin/jar -c0vf javamesa.jar MESA/*/*class *class

mesaweb:	mesaweb.jar
	../scripts/createdirectory $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
	$(INSTALL) mesaweb.jar $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib

mesaweb.jar:
	cd MESA/Servlet; make
	$(JDK_ROOT)/bin/jar -c0vf mesaweb.jar MESA/Servlet/*class
	$(INSTALL) mesaweb.jar $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib

fastjar:
	$(JDK_ROOT)/bin/jar -c0vf javamesa.jar MESA/*/*class *class

