
classes: IHESVSGetHTTP.class

IHESVSGetHTTP.class: IHESVSGetHTTP.java
	$(JAVA_HOME)/bin/javac IHESVSGetHTTP.java

clean:
	rm -f *.class

docs:
	$(JAVA_HOME)/bin/javadoc -d $(MESA_ROOT)/webmesa/mesa-iti/doc *.java

test:	TestSQL.class
	$(JAVA_HOME)/bin/java TestSQL

TestSQL.class: TestSQL.java
	$(JAVA_HOME)/bin/javac TestSQL.java
