
classes: DomainObject.class InformationSource.class SQLInterface.class IHERetrieveDocumentInfo.class

DomainObject.class: DomainObject.java
	$(JAVA_HOME)/bin/javac DomainObject.java

InformationSource.class: InformationSource.java
	$(JAVA_HOME)/bin/javac InformationSource.java

SQLInterface.class: SQLInterface.java
	$(JAVA_HOME)/bin/javac SQLInterface.java

IHERetrieveDocumentInfo.class: IHERetrieveDocumentInfo.java
	$(JAVA_HOME)/bin/javac IHERetrieveDocumentInfo.java

clean:
	rm -f *.class

docs:
	$(JAVA_HOME)/bin/javadoc -d $(MESA_ROOT)/webmesa/mesa-iti/doc *.java

test:	TestSQL.class
	$(JAVA_HOME)/bin/java TestSQL

TestSQL.class: TestSQL.java
	$(JAVA_HOME)/bin/javac TestSQL.java
