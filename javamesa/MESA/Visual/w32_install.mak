# Makefile for 

install:
	$(MAKE)/f w32_install.mak CompositeEditor.class
	$(MAKE)/f w32_install.mak CompositeObjectTable.class
	$(MAKE)/f w32_install.mak CompositePainter.class
	$(MAKE)/f w32_install.mak ContentItemNode.class
	$(MAKE)/f w32_install.mak ContentItemNodeCODE.class
	$(MAKE)/f w32_install.mak ContentItemNodeCONTAINER.class
	$(MAKE)/f w32_install.mak ContentItemNodeFactory.class
	$(MAKE)/f w32_install.mak ContentItemNodeIMAGE.class
	$(MAKE)/f w32_install.mak ContentItemNodePNAME.class
	$(MAKE)/f w32_install.mak ContentItemNodeTEXT.class
	$(MAKE)/f w32_install.mak ContentItemNodeUIDREF.class

CompositeEditor.class: CompositeEditor.java
	javac CompositeEditor.java\

CompositeObjectTable.class: CompositeObjectTable.java
	javac CompositeObjectTable.java

CompositePainter.class: CompositePainter.java
	javac CompositePainter.java

ContentItemNode.class: ContentItemNode.java
	javac ContentItemNode.java

ContentItemNodeCODE.class: ContentItemNodeCODE.java
	javac ContentItemNodeCODE.java

ContentItemNodeCONTAINER.class: ContentItemNodeCONTAINER.java
	javac ContentItemNodeCONTAINER.java

ContentItemNodeFactory.class: ContentItemNodeFactory.java
	javac ContentItemNodeFactory.java

ContentItemNodeIMAGE.class: ContentItemNodeIMAGE.java
	javac ContentItemNodeIMAGE.java

ContentItemNodePNAME.class: ContentItemNodePNAME.java
	javac ContentItemNodePNAME.java

ContentItemNodeTEXT.class: ContentItemNodeTEXT.java
	javac ContentItemNodeTEXT.java

ContentItemNodeUIDREF.class: ContentItemNodeUIDREF.java
	javac ContentItemNodeUIDREF.java

clean:
	del *.class
