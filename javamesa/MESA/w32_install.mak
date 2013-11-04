install:
	cd "Visual"
	$(MAKE)/f w32_install.mak install
	cd ".."

clean:
	cd "Visual"
	$(MAKE)/f w32_install.mak clean
	cd ".."
