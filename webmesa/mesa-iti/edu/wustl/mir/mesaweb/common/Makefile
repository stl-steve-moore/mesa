
classes: DomainObject.class SQLInterface.class

DomainObject.class: DomainObject.java
	$(JAVA_HOME)/bin/javac DomainObject.java

SQLInterface.class: SQLInterface.java
	$(JAVA_HOME)/bin/javac SQLInterface.java

clean:
	rm -f *.class

docs:
	$(JAVA_HOME)/bin/javadoc -d $(MESA_ROOT)/webmesa/mesa-iti/doc *.java

test:	TestSQL.class
	$(JAVA_HOME)/bin/java TestSQL

TestSQL.class: TestSQL.java
	$(JAVA_HOME)/bin/javac TestSQL.java
