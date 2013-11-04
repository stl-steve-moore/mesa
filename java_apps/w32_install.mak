install:
	cd ObjectViewer
	$(JAVA_HOME)\bin\javac DICOMObjectViewer.java
	$(JAVA_HOME)\bin\javac DOMParser.java
	$(JAVA_HOME)\bin\jar cf ..\ObjectViewer.jar *class
	cd ..

	cd KeyImageNote
	$(JAVA_HOME)\bin\jar cf ..\KeyImageNote.jar *class
	cd ..

	cd SRComposer
	$(JAVA_HOME)\bin\jar cf ..\SRComposer.jar *class
	cd ..

	cd SRRenderTest
	$(JAVA_HOME)\bin\jar cf ..\SRRenderTest.jar *class
	cd ..

	copy KeyImageNote.jar $(JAR_DIRECTORY)
	copy SRComposer.jar $(JAR_DIRECTORY)
	copy SRRenderTest.jar $(JAR_DIRECTORY)
	copy jar\*jar $(JAR_DIRECTORY)
	copy gif $(MESA_TARGET)\runtime\gif

clean:
	del *.jar
