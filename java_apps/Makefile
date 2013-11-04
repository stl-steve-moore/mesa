install:
	cd ObjectViewer; $(MAKE) install
	cd KeyImageNote; $(JDK_ROOT)/bin/jar cf ../KeyImageNote.jar *class
	cd SRComposer; $(JDK_ROOT)/bin/jar cf ../SRComposer.jar *class
	cd SRRenderTest; $(JDK_ROOT)/bin/jar cf ../SRRenderTest.jar *class
	$(INSTALL) KeyImageNote.jar $(JAR_DIRECTORY)
	$(INSTALL) SRComposer.jar $(JAR_DIRECTORY)
	$(INSTALL) SRRenderTest.jar $(JAR_DIRECTORY)
	$(INSTALL) jar/*jar $(JAR_DIRECTORY)
	cp -rpf gif $(MESA_TARGET)/runtime

#	cd ObjectViewer; $(JDK_ROOT)/bin/javac DICOMObjectViewer.java
#	$(JDK_ROOT)/bin/javac DOMParser.java
#	$(JDK_ROOT)/bin/jar cf ../ObjectViewer.jar *class
