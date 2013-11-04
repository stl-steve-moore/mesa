
TestSQL.class: TestSQL.java
	javac TestSQL.java

clean:
	del/q *.class
 
t1:	TestSQL.class
	java  -Djava.security.manager TestSQL W32
	java   TestSQL W32
