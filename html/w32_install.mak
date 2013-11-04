install:
	$(MESA_ROOT)\scripts\createdirectory.bat $(MESA_TARGET)\html
	xcopy/E/Y ecg $(MESA_TARGET)\html
	xcopy/E/Y rid $(MESA_TARGET)\html
