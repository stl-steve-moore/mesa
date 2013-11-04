include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

app:	tpl_to_txt.pl

install:	app
	$(INSTALL) -d $(MESA_STORAGE)/hl7
	$(INSTALL) -d $(MESA_STORAGE)/scratch
	$(INSTALL) text_var_sub.pl $(MESA_BIN)
	$(INSTALL) tpl_to_txt.pl $(MESA_BIN)
	$(INSTALL) hl7_attach_PDF.pl $(MESA_BIN)
	$(INSTALL) createdirectory $(MESA_BIN)
	$(INSTALL) startSimpleStorage $(MESA_BIN)
	$(INSTALL) SRComposer.csh $(MESA_BIN)
	$(INSTALL) SRRender.csh $(MESA_BIN)
	$(INSTALL) KeyImageNote.csh $(MESA_BIN)
	$(INSTALL) mesa_version.csh $(MESA_BIN)
	$(INSTALL) mesa_construct_hl7.pl $(MESA_BIN)
	$(INSTALL) mesa_def_*.pl $(MESA_BIN)
	$(INSTALL) mesa_clone_series.pl $(MESA_BIN)
	$(INSTALL) start_ris_mall_servers.csh $(MESA_BIN)
	$(INSTALL) stop_ris_mall_servers.csh $(MESA_BIN)

clean:

test_a01:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-V 1 a01 /usr/local/MESA-src/templates/hl7/a01.tpl \
		webadt 1 $(MESA_STORAGE)/hl7/x_a01
test_a03:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-V 1 a03 /usr/local/MESA-src/templates/hl7/a03.tpl \
        webadt 1 $(MESA_STORAGE)/hl7/x_a03
test_a04:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-V 1 a04 /usr/local/MESA-src/templates/hl7/a04.tpl \
        webadt 1 $(MESA_STORAGE)/hl7/x_a04
test_a08:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-V 1 -N NEW^NAME a08 /usr/local/MESA-src/templates/hl7/a08.tpl \
		webadt 1 $(MESA_STORAGE)/hl7/x_a08
test_a40:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-P 1 -p 2 a40 /usr/local/MESA-src/templates/hl7/a40.tpl \
		webadt 1 $(MESA_STORAGE)/hl7/x_a40
test_o01-order:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-O 1 o01-order /usr/local/MESA-src/templates/hl7/o01-order.tpl \
		webop 1 $(MESA_STORAGE)/hl7/x_o01-order
test_o01-sched:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-M 1 o01-sched /usr/local/MESA-src/templates/hl7/o01-sched.tpl \
		webof 1 $(MESA_STORAGE)/hl7/x_o01-sched
test_o01-cancel:
	perl mesa_construct_hl7.pl -v -t $(MESA_STORAGE)/scratch \
		-M 1 o01-cancel /usr/local/MESA-src/templates/hl7/o01-cancel.tpl \
		webof 1 $(MESA_STORAGE)/hl7/x_o01-cancel
