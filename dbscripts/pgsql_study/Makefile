# Makefile to create MESA Databases with tables for all simulators

database:
	./CreateDB adt
	./CreateDB ordplc
	./CreateDB ordfil
	./CreateDB mod1
	./CreateDB mod2
	./CreateDB imgmgr_study
	./CreateDB wkstation
	./CreateDB rpt_repos
	./CreateDB rpt_manager
#	./CreateDB queue_info

	./CreateADTTables.script adt
	./CreateOrdPlcTables.script ordplc
	./CreateOrdFilTables.script ordfil
	./CreateModTables.script mod1
	./CreateModTables.script mod2
	./CreateImgMgrTables.script imgmgr_study
	./CreateImgMgrTables.script wkstation
	./CreateImgMgrTables.script rpt_repos
	./CreateImgMgrTables.script rpt_manager
	./CreateQueueMgrTables.script imgmgr_study

	psql imgmgr_study < loaddicomapp.pgsql
	psql rpt_repos < loaddicomapp.pgsql

clear:
	./ClearADTTables.script adt
	./ClearOrdPlcTables.script ordplc
	perl ./ClearOrdFilTables.script ordfil
	./ClearModTables.script mod1
	./ClearModTables.script mod2
	perl ./ClearImgMgrTables.pl imgmgr_study
	perl ./ClearImgMgrTables.pl wkstation
	perl ./ClearImgMgrTables.pl rpt_repos
	perl ./ClearImgMgrTables.pl rpt_manager
	perl ./ClearQueueMgrTables.pl queue_info


uninstall:
	dropdb adt
	dropdb ordplc
	dropdb ordfil
	dropdb mod1
	dropdb mod2
	dropdb imgmgr_study
	dropdb wkstation
	dropdb rpt_repos
	dropdb rpt_manager
#	dropdb queue_info

imgmgr:
	psql imgmgr_study < loaddicomapp.pgsql

# Install these files in target directory.
install:
	cp -r * $(MESA_TARGET)/db
