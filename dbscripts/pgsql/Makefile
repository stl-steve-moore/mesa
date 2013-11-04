# Makefile to create MESA Databases with tables for all simulators
#PERL = /usr/bin/perl
PERL = perl
#PSQL = /usr/bin/psql
PSQL = psql

database: 
	./CreateDB adt
	./CreateDB ordplc
	./CreateDB ordfil
	./CreateDB mod1
	./CreateDB mod2
	./CreateDB expmgr
	./CreateDB exprcr
	./CreateDB imgmgr
	./CreateDB imgmgr_study
	./CreateDB wkstation
	./CreateDB rpt_repos
	./CreateDB rpt_manager
	./CreateDB syslog
	./CreateDB xref_mgr
	./CreateDB info_src
	./CreateDB pd_supplier
	./CreateDB svs
#	./CreateDB doc_reference
#
	./CreateADTTables.script adt
	./CreateOrdPlcTables.script ordplc
	./CreateOrdFilTables.script ordfil
	./CreateModTables.script mod1
	./CreateModTables.script mod2
	./CreateImgMgrTables.script expmgr
	./CreateImgMgrTables.script exprcr
	./CreateImgMgrTables.script imgmgr
	./CreateImgMgrTables_StudyRoot.csh imgmgr_study
	./CreateQueueMgrTables.csh imgmgr_study
	./CreateImgMgrTables.script wkstation
	./CreateImgMgrTables.script rpt_repos
	./CreateImgMgrTables.script rpt_manager
	./CreateSyslogTables.script syslog
#
	./CreateXRefMgrTables.csh xref_mgr
	./CreateInfoSrcTables.csh info_src
	./CreateXRefMgrTables.csh pd_supplier
	./CreateSVSTables.csh svs
#	./CreateDocReferenceTables.csh doc_reference
#
	$(PSQL) imgmgr < loaddicomapp.pgsql
	$(PSQL) expmgr < loaddicomapp.pgsql
	$(PSQL) exprcr < loaddicomapp.pgsql
	$(PSQL) imgmgr_study < dicomapp_test.sql
	$(PSQL) rpt_repos < loaddicomapp.pgsql
	$(PSQL) svs < load_svs_data.sql

clear:
	./ClearADTTables.script adt
	./ClearOrdPlcTables.script ordplc
	$(PERL) ./ClearOrdFilTables.script ordfil
	./ClearModTables.script mod1
	./ClearModTables.script mod2
	$(PERL) ./ClearImgMgrTables.pl expmgr
	$(PERL) ./ClearImgMgrTables.pl exprcr
	$(PERL) ./ClearImgMgrTables.pl imgmgr
	$(PERL) ./ClearImgMgr_StudyRoot.pl imgmgr_study
	$(PERL) ./ClearImgMgrTables.pl wkstation
	$(PERL) ./ClearImgMgrTables.pl rpt_repos
	$(PERL) ./ClearImgMgrTables.pl rpt_manager
	$(PERL) ./ClearSyslogTables.pl syslog

uninstall:
	-./DropDB adt
	-./DropDB ordplc
	-./DropDB ordfil
	-./DropDB mod1
	-./DropDB mod2
	-./DropDB expmgr
	-./DropDB exprcr
	-./DropDB imgmgr
	-./DropDB imgmgr_study
	-./DropDB wkstation
	-./DropDB rpt_repos
	-./DropDB rpt_manager
	-./DropDB syslog
	./DropDB xref_mgr
	./DropDB info_src
	./DropDB pd_supplier
	./DropDB svs
#	./DropDB doc_reference

imgmgr:
	$(PSQL) imgmgr < loaddicomapp.pgsql

# Install these files in target directory.
install:
	cp -r * $(MESA_TARGET)/db

syslog:
	./DropDB syslog
	./CreateDB syslog
	./CreateSyslogTables.script syslog
