install:
	$(MAKE)/f javactn.mak CFG="javactn - Win32 Debug"
	copy Debug\javactn.dll $(MESA_TARGET)\bin

clean:
	$(MAKE)/f javactn.mak clean
