
install:
	cp blank.html $(TOMCAT_HOME)/webapps/ROOT
	cp mesa-db-viewer-control.html $(TOMCAT_HOME)/webapps/ROOT
	cp mesa.html $(TOMCAT_HOME)/webapps/ROOT
#	cp mesa_db_viewer.html $(TOMCAT_HOME)/webapps/ROOT
	cp web.xml $(TOMCAT_HOME)/webapps/ROOT/WEB-INF
	cp tomcat-users.xml $(TOMCAT_HOME)/conf

install_user_view:
	rm -f mesaweb_user.jar
	$(MAKE) mesaweb_user.jar
	../../scripts/createdirectory $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
	$(INSTALL) mesaweb_user.jar $(TOMCAT_HOME)/webapps/ROOT/WEB-INF/lib
	cd user_view; $(MAKE) install


P = edu/wustl/mir/mesaweb
mesaweb_user.jar:
	cd edu/wustl/mir/mesaweb; make
	$(JDK_ROOT)/bin/jar -c0vf mesaweb_user.jar $(P)/*.class
