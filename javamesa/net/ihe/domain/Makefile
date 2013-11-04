classes: DBInterface.class DomainObject.class Study.class

DBInterface.class: DBInterface.java
	$(JAVA_HOME)/bin/javac DBInterface.java

DomainObject.class: DomainObject.java
	$(JAVA_HOME)/bin/javac DomainObject.java

Study.class: Study.java
	$(JAVA_HOME)/bin/javac Study.java

clean: 
	rm -f *.class

t1:	classes
	$(JAVA_HOME)/bin/java net/ihe/domain/Study   imgmgr smm smm
