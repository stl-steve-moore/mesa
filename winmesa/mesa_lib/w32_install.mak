install:
	$(MAKE) /f mesa_lib.mak CFG="mesa_lib - Win32 Release"

clean:
	$(MAKE) /f mesa_lib.mak CFG="mesa_lib - Win32 Release" clean

install_debug:
	$(MAKE) /f mesa_lib.mak CFG="mesa_lib - Win32 Debug"

clean_debug:
	$(MAKE) /f mesa_lib.mak CFG="mesa_lib - Win32 Debug" clean
