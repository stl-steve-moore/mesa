#This is deprecated, so we change the first target
# from install to install_xx. That should cause the installation
# to fail.
# moore 2004.09.09

install_xx:
	..\..\scripts\createdirectory.bat $(MESA_TARGET)\db
	copy *.sql $(MESA_TARGET)\db
	copy *.bat $(MESA_TARGET)\db
	copy *.pl $(MESA_TARGET)\db
	copy w32_install.mak $(MESA_TARGET)\db

database:
	.\CreateADTTables.bat adt
	.\CreateOrdPlcTables.bat ordplc
	.\CreateOrdFilTables.bat ordfil
	.\CreateModTables.bat mod1
	.\CreateModTables.bat mod2
	.\CreateImgMgrTables.bat imgmgr
	.\CreateImgMgrTables.bat wkstation
	.\CreateImgMgrTables.bat rpt_repos
	.\CreateImgMgrTables.bat rpt_manager
	.\CreateSyslogTables.bat syslog

drop:
	.\DropADTTables.bat adt
	.\DropOrdPlcTables.bat ordplc
	.\DropOrdFilTables.bat ordfil
	.\DropModTables.bat mod1
	.\DropModTables.bat mod2
	.\DropImgMgrTables.bat imgmgr
	.\DropImgMgrTables.bat wkstation
	.\DropImgMgrTables.bat rpt_repos
	.\DropImgMgrTables.bat rpt_manager
	.\DropSyslogTables.bat syslog