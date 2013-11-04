
classes: DomainObject.class InformationSource.class SQLInterface.class IHERetrieveDocumentInfo.class

DomainObject.class: DomainObject.java
	javac DomainObject.java

InformationSource.class: InformationSource.java
	javac InformationSource.java

SQLInterface.class: SQLInterface.java
	javac SQLInterface.java

IHERetrieveDocumentInfo.class: IHERetrieveDocumentInfo.java
	javac IHERetrieveDocumentInfo.java

clean:
	del/q *.class

test:	TestSQL.class
	java TestSQL

TestSQL.class: TestSQL.java
	javac TestSQL.java
