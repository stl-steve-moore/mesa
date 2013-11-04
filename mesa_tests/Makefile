
install_y1:
	$(MESA_ROOT)/scripts/createdirectory $(MESA_TARGET)/testsuite

	tar cf - july | ( cd $(MESA_TARGET)/testsuite; tar xf -)

	tar cf - y1she | ( cd $(MESA_TARGET)/testsuite; tar xf -)

	find $(MESA_TARGET)/testsuite -name '*.pl' -exec chmod +x {} \;
	find $(MESA_TARGET)/testsuite -name '*.csh' -exec chmod +x {} \;

install:
	$(MESA_ROOT)/scripts/createdirectory $(MESA_TARGET)/mesa_tests
	cd card/msgs; perl create_messages.pl
	cd iti/msgs; perl create_messages.pl
	cd rad/msgs; perl create_messages.pl
	cd rad/actors/common; perl scripts/create_txt_html.pl
	cd card/actors/common; perl scripts/create_txt_html.pl

	tar cf - card common docs iti rad pcc | ( cd $(MESA_TARGET)/mesa_tests; tar xf -)

	find $(MESA_TARGET)/mesa_tests/card -name '*.pl' -exec chmod +x {} \;
	find $(MESA_TARGET)/mesa_tests/card -name '*.csh' -exec chmod +x {} \;
	find $(MESA_TARGET)/mesa_tests/iti -name '*.pl' -exec chmod +x {} \;
	find $(MESA_TARGET)/mesa_tests/iti -name '*.csh' -exec chmod +x {} \;
	find $(MESA_TARGET)/mesa_tests/rad -name '*.pl' -exec chmod +x {} \;
	find $(MESA_TARGET)/mesa_tests/rad -name '*.csh' -exec chmod +x {} \;


connectathon:
	tar cf - y2_connectathon | ( cd $(MESA_TARGET)/testsuite; tar xf -)

	find $(MESA_TARGET)/testsuite/y2_connectathon -name '*.pl' -exec chmod +x {} \;
	find $(MESA_TARGET)/testsuite/y2_connectathon -name '*.csh' -exec chmod +x {} \;
