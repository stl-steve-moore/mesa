install:
	..\..\scripts\createdirectory.bat $(MESA_TARGET)\webmesa\mesa-iti
	%MESA_ROOT%\scripts\createdirectory.bat %TOMCAT_HOME%\webapps\ROOT\WEB-INF\lib
	copy rid.html %TOMCAT_HOME%\webapps\ROOT
	copy ecg.html %TOMCAT_HOME%\webapps\ROOT
	copy IHEDocumentList.xsl %TOMCAT_HOME%\webapps\ROOT
	copy web_w32_sqlserver.xml  %TOMCAT_HOME%\webapps\ROOT\WEB-INF\web.xml
	copy w32_install.mak mesaweb_rid.jar
	del/f/q mesaweb_rid.jar
	nmake/f w32_install.mak mesaweb_rid.jar
	copy mesaweb_rid.jar %TOMCAT_HOME%\common\lib
	copy rid.html $(MESA_TARGET)\webmesa\mesa-iti
	copy ecg.html $(MESA_TARGET)\webmesa\mesa-iti
	copy IHEDocumentList.xsl $(MESA_TARGET)\webmesa\mesa-iti
	copy web_w32_sqlserver.xml  $(MESA_TARGET)\webmesa\mesa-iti
	copy mesaweb_rid.jar $(MESA_TARGET)\webmesa\mesa-iti
	copy install.bat $(MESA_TARGET)\webmesa\mesa-iti

P = edu\wustl\mir\mesaweb\rid
mesaweb_rid.jar:
	cd $(P)
	nmake/f w32_install.mak
	cd ..\..\..\..\..
	jar -c0vf mesaweb_rid.jar $(P)\*.class

clean:
	cd $(P)
	nmake/f w32_install.mak clean
	cd ..\..\..\..\..
