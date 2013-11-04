
#install: classes
#	$(MESA_TARGET)/bin/createdirectory $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp IMSeriesPage.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp IMStudyPage.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp ImageManager.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp HtmlHelper.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes
#	cp SQLStatement.class $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/classes

classes: HtmlHelper.class IMSeriesPage.class IMStudyPage.class ImageManager.class QueueManager.class SQLStatement.class UserManager.class

HtmlHelper.class: HtmlHelper.java
	$(JDK_ROOT)/bin/javac HtmlHelper.java

IMDelete.class: IMDelete.java
	$(JDK_ROOT)/bin/javac IMDelete.java

IMSeriesPage.class: IMSeriesPage.java
	$(JDK_ROOT)/bin/javac IMSeriesPage.java

IMStudyPage.class: IMStudyPage.java
	$(JDK_ROOT)/bin/javac IMStudyPage.java

IMUpdate.class: IMUpdate.java
	$(JDK_ROOT)/bin/javac IMUpdate.java

ImageManager.class: ImageManager.java
	$(JDK_ROOT)/bin/javac ImageManager.java

QueueManager.class: QueueManager.java
	$(JDK_ROOT)/bin/javac QueueManager.java

SQLStatement.class: SQLStatement.java
	$(JDK_ROOT)/bin/javac  SQLStatement.java

UserManager.class: UserManager.java
	$(JDK_ROOT)/bin/javac UserManager.java

clean:
	rm -f *.class

