@echo off

if %TOMCAT_HOME% == "" echo You must set the TOMCAT_HOME environment variable
if %TOMCAT_HOME% == "" goto end
if %MESA_TARGET% == "" echo You must set the MESA_TARGET environment variable
if %MESA_TARGET% == "" goto end

copy ecg.html %TOMCAT_HOME%\webapps\ROOT
copy rid.html %TOMCAT_HOME%\webapps\ROOT
copy IHEDocumentList.xsl %TOMCAT_HOME%\webapps\ROOT
copy web_w32_sqlserver.xml  %TOMCAT_HOME%\webapps\ROOT\WEB-INF\web.xml
%MESA_TARGET%\bin\createdirectory.bat %TOMCAT_HOME%\webapps\ROOT\WEB-INF\lib
copy mesaweb_rid.jar %TOMCAT_HOME%\webapps\ROOT\WEB-INF\lib

echo Make sure you copy 3 SQL Server JDBC JAR files to %TOMCAT_HOME%\common\lib

:end
