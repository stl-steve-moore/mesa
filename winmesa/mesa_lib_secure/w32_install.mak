install:
	$(MAKE) /f mesa_lib_secure.mak CFG="mesa_lib_secure - Win32 Release"

clean:
	$(MAKE) /f mesa_lib_secure.mak CFG="mesa_lib_secure - Win32 Release" clean

install_debug:
	$(MAKE) /f mesa_lib_secure.mak CFG="mesa_lib_secure - Win32 Debug"

clean_debug:
	$(MAKE) /f mesa_lib_secure.mak CFG="mesa_lib_secure - Win32 Debug" clean
