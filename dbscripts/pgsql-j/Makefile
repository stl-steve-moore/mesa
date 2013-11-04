# Makefile to create MESA Databases with tables for all simulators
RIS_MALL_DIR = $(MESA_TARGET)/webmesa/ris_mall

database:
	./CreateDB.csh adt
	./CreateDB.csh ordplc
	./CreateDB.csh ordfil
	./CreateDB.csh mod1
#	./CreateDB.csh mod2
	./CreateDB.csh imgmgr
#	./CreateDB.csh imgmgr_study
	./CreateDB.csh wkstation
	./CreateDB.csh rpt_repos
	./CreateDB.csh rpt_manager
	./CreateDB.csh syslog
#
#	./CreateADTTables.script adt
	./CreateOrdPlcTables.csh ordplc
	./CreateOrdFilTables.csh ordfil
	./CreateModTables.csh mod1
#	./CreateModTables.script mod2
	./CreateImgMgrTables.csh imgmgr
#	./CreateImgMgrTables_StudyRoot.csh imgmgr_study
#	./CreateQueueMgrTables.csh imgmgr_study
	./CreateImgMgrTables.csh wkstation
	./CreateImgMgrTables.csh rpt_repos
	./CreateImgMgrTables.csh rpt_manager
	./CreateSyslogTables.csh syslog
#
	psql imgmgr < loaddicomapp.sql
#	psql imgmgr_study < dicomapp_test.sql
	psql rpt_repos < loaddicomapp.sql
clear:
	./ClearADTTables.script adt
	./ClearOrdPlcTables.script ordplc
	perl ./ClearOrdFilTables.script ordfil
	./ClearModTables.script mod1
	./ClearModTables.script mod2
	perl ./ClearImgMgrTables.pl imgmgr
	perl ./ClearImgMgr_StudyRoot.pl imgmgr_study
	perl ./ClearImgMgrTables.pl wkstation
	perl ./ClearImgMgrTables.pl rpt_repos
	perl ./ClearImgMgrTables.pl rpt_manager
	perl ./ClearSyslogTables.pl syslog

uninstall:
	./DropDB.csh adt
	./DropDB.csh ordplc
	./DropDB.csh ordfil
	./DropDB.csh mod1
#	-./DropDB.csh mod2
	./DropDB.csh imgmgr
#	-./DropDB.csh imgmgr_study
	./DropDB.csh wkstation
	./DropDB.csh rpt_repos
	./DropDB.csh rpt_manager
	./DropDB.csh syslog
#	-./DropDB.csh webadt
#	-./DropDB.csh webof
#	-./DropDB.csh webop

imgmgr:
	psql imgmgr < loaddicomapp.pgsql

# Install these files in target directory.
install:
	cp -r * $(MESA_TARGET)/db

syslog:
	./DropDB.csh syslog
	./CreateDB.csh syslog
	./CreateSyslogTables.csh syslog

# Entries for ITI data
iti:
	./CreateDB.csh xref_mgr
	psql xref_mgr < createpatient.sql

clear-iti:
	./DropDB.csh xref_mgr

webmesa:
	./CreateDB.csh webadt
	./CreateDB.csh webof
	./CreateDB.csh webop
	./CreateDB.csh ris_mall
	./CreateWebADTTables.csh webadt
	./CreateWebOrdPlcTables.csh webop
	./CreateWebOrdFilTables.csh webof
	perl ./fillLogTables.pl -d ris_mall
	psql ris_mall < user.sql
	psql ris_mall < createadminaccount.sql
	perl ./fillUserTables.pl -f $(RIS_MALL_DIR)/config/user_names.txt ris_mall
	perl ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webadt.txt webadt
	perl ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webop.txt webop
	perl ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webof.txt webof

webmesa_uninstall:
	-./DropDB.csh webadt
	-./DropDB.csh webop
	-./DropDB.csh webof
	-./DropDB.csh ris_mall
