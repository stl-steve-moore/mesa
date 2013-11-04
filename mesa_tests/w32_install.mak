install:
	$(MAKE) /f w32_install.mak x_testdata

x_testdata:
	cd "card\msgs"
	perl create_messages.pl
	cd "..\.."
	cd "card\actors\common"
	perl scripts\create_txt_html.pl
	cd "..\..\.."
	if not exist $(MESA_TARGET)\mesa_tests\card md $(MESA_TARGET)\mesa_tests\card
	xcopy/E/I/Y card $(MESA_TARGET)\mesa_tests\card
	cd "iti\msgs"
	perl create_messages.pl
	cd "..\.."
	if not exist $(MESA_TARGET)\mesa_tests\iti md $(MESA_TARGET)\mesa_tests\iti
	xcopy/E/I/Y iti $(MESA_TARGET)\mesa_tests\iti
	cd "rad\msgs"
	perl create_messages.pl
	cd "..\.."
	cd "rad\actors\common"
	perl scripts\create_txt_html.pl
	cd "..\..\.."
	if not exist $(MESA_TARGET)\mesa_tests\rad md $(MESA_TARGET)\mesa_tests\rad
	xcopy/E/I/Y rad $(MESA_TARGET)\mesa_tests\rad
	if not exist $(MESA_TARGET)\mesa_tests\common md $(MESA_TARGET)\mesa_tests\common
	xcopy/E/I/Y common $(MESA_TARGET)\mesa_tests\common
	if not exist $(MESA_TARGET)\mesa_tests\docs md $(MESA_TARGET)\mesa_tests\docs
	xcopy/E/I/Y docs $(MESA_TARGET)\mesa_tests\docs
	if not exist $(MESA_TARGET)\mesa_tests\pcc md $(MESA_TARGET)\mesa_tests\pcc
	xcopy/E/I/Y pcc $(MESA_TARGET)\mesa_tests\pcc

x_txt_html:
	cd "rad\actors\common"
	perl scripts\create_txt_html.pl
