# Makefile to create MESA Databases with tables for the Ris Mall
PERL = /usr/bin/perl
PSQL = /usr/bin/psql
RIS_MALL_DIR = $(MESA_TARGET)/webmesa/ris_mall

# Install these files in target directory.
install:
	cp -r * $(MESA_TARGET)/db-rismall

database:
	./CreateDB webadt
	./CreateDB webof
	./CreateDB webop
	./CreateDB ris_mall
	./CreateWebADTTables.csh webadt
	./CreateWebOrdPlcTables.csh webop
	./CreateWebOrdFilTables.csh webof
	$(PERL) ./fillLogTables.pl -d ris_mall
	$(PSQL) ris_mall < user.sql
	$(PSQL) ris_mall < createadminaccount.sql
	$(PERL) ./fillUserTables.pl -f $(RIS_MALL_DIR)/config/user_names.txt ris_mall
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webadt.txt webadt
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webop.txt webop
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webof.txt webof

uninstall:
	-./DropDB webadt
	-./DropDB webop
	-./DropDB webof
	-./DropDB ris_mall

reload_destination:
	$(PERL) ./fillDestinationTables.pl -c webadt
	$(PERL) ./fillDestinationTables.pl -c webop
	$(PERL) ./fillDestinationTables.pl -c webof
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webadt.txt webadt
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webop.txt  webop
	$(PERL) ./fillDestinationTables.pl -f $(RIS_MALL_DIR)/config/hl7_dest_webof.txt  webof
