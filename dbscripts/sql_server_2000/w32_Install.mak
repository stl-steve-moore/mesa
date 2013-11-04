install:
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
	.\CreateImgMgrTables.bat expmgr
	.\CreateImgMgrTables.bat exprcr
	.\CreateImgMgrTables.bat imgmgr
	.\CreateImgMgrTables.bat wkstation
	.\CreateImgMgrTables.bat rpt_repos
	.\CreateImgMgrTables.bat rpt_manager
	.\CreateSyslogTables.bat syslog
	.\CreateInfoSrcTables.bat info_src
	.\CreateXRefMgrTables.bat xref_mgr
	.\CreateXRefMgrTables.bat pd_supplier


drop:
	.\DropADTTables.bat adt
	.\DropOrdPlcTables.bat ordplc
	.\DropOrdFilTables.bat ordfil
	.\DropModTables.bat mod1
	.\DropModTables.bat mod2
	.\DropImgMgrTables.bat expmgr
	.\DropImgMgrTables.bat exprcr
	.\DropImgMgrTables.bat imgmgr
	.\DropImgMgrTables.bat wkstation
	.\DropImgMgrTables.bat rpt_repos
	.\DropImgMgrTables.bat rpt_manager
	.\DropSyslogTables.bat syslog
	.\DropInfoSrcTables.bat info_src
	.\DropXRefMgrTables.bat xref_mgr
	.\DropXRefMgrTables.bat pd_supplier
