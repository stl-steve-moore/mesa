include $(DICOM_MAKE)

install: classes
	$(MESA_TARGET)/bin/createdirectory \
$(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp ImgMgrViewer.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes

classes: HtmlHelper.class ImgMgrViewer.class PatientStudyTable.class SeriesTable.class SOPInstanceTable.class StorageManager.class

HtmlHelper.class: HtmlHelper.java
	$(JDK_ROOT)/bin/javac HtmlHelper.java

ImgMgrViewer.class: ImgMgrViewer.java
	$(JDK_ROOT)/bin/javac ImgMgrViewer.java

PatientStudyTable.class: PatientStudyTable.java
	$(JDK_ROOT)/bin/javac PatientStudyTable.java

SeriesTable.class: SeriesTable.java
	$(JDK_ROOT)/bin/javac SeriesTable.java

SOPInstanceTable.class: SOPInstanceTable.java
	$(JDK_ROOT)/bin/javac SOPInstanceTable.java

StorageManager.class: StorageManager.java
	$(JDK_ROOT)/bin/javac StorageManager.java

X:	X.class

X.class: X.java
	$(JDK_ROOT)/bin/javac X.java

x:	X.class
	$(JDK_ROOT)/bin/java -cp .:/opt/postgres/share/java/postgresql.jar X

clean:
	rm -f $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes/HtmlHelper.class
	rm -f $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes/ImgMgrViewer.class
	rm -f $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes/PatientStudy.class
	rm -f *.class

