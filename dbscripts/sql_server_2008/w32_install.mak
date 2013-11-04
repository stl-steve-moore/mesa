install:
	..\..\scripts\createdirectory.bat $(MESA_TARGET)\db
	..\..\scripts\createdirectory.bat $(MESA_TARGET)\db\sqlfiles
	copy ..\sql_server_base\*.sql $(MESA_TARGET)\db\sqlfiles
	copy *.bat $(MESA_TARGET)\db
	copy *.pl $(MESA_TARGET)\db
	copy w32_install.mak $(MESA_TARGET)\db

database:
	echo You need to use the create database perl script



drop:
	echo You need to use the drop database perl script

