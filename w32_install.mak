MSFTVS8="C:\Program Files\Microsoft Visual Studio 8\VC\redist\x86\Microsoft.VC80.CRT"


install :
	$(MAKE) /f w32_install.mak directories
	$(MAKE) /f w32_install.mak headers
	$(MAKE) /f w32_install.mak library
#	$(MAKE) /f w32_install.mak java
	$(MAKE) /f w32_install.mak x_webmesa
	$(MAKE) /f w32_install.mak x_apps
	$(MAKE) /f w32_install.mak x_dlls
	$(MAKE) /f w32_install.mak x_runtime
	$(MAKE) /f w32_install.mak x_scripts
	$(MAKE) /f w32_install.mak x_dbscripts
	$(MAKE) /f w32_install.mak x_html
	$(MAKE) /f w32_install.mak iti_html
#	$(MAKE) /f w32_install.mak x_testdata

install_secure:
	$(MAKE) /f w32_install.mak x_secure_headers
	$(MAKE) /f w32_install.mak x_secure_lib
	$(MAKE) /f w32_install.mak x_secure_apps

rebuild:
	$(MAKE) /f w32_install.mak clean
	$(MAKE) /f w32_install.mak install

rebuild_secure:
	$(MAKE) /f w32_install.mak clean_secure
	$(MAKE) /f w32_install.mak install_secure

rebuild_all:
	$(MAKE) /f w32_install.mak clean
	$(MAKE) /f w32_install.mak clean_debug
	$(MAKE) /f w32_install.mak install
	$(MAKE) /f w32_install.mak install_debug

directories:
	scripts\createdirectory.bat include
	scripts\createdirectory.bat $(MESA_TARGET)\lib
	scripts\createdirectory.bat $(MESA_TARGET)\logs
	scripts\createdirectory.bat $(MESA_TARGET)\bin
	scripts\createdirectory.bat $(MESA_TARGET)\data
	scripts\createdirectory.bat $(MESA_TARGET)\db
	scripts\createdirectory.bat $(MESA_TARGET)\db\sqlfiles
	scripts\createdirectory.bat $(MESA_TARGET)\pids
	scripts\createdirectory.bat $(MESA_TARGET)\runtime
#	scripts\createdirectory.bat $(MESA_TARGET)\testsuite
#	scripts\createdirectory.bat $(MESA_TARGET)\testsuite\y3_actor

clean:
	$(MAKE) /f w32_install.mak library_clean
	$(MAKE) /f w32_install.mak java_clean
	$(MAKE) /f w32_install.mak apps_clean

clean_secure:
	$(MAKE) /f w32_install.mak secure_library_clean
	$(MAKE) /f w32_install.mak secure_apps_clean

headers :
	cd "winmesa\scripts"
	headerexport.bat
	cd "..\.."

	cd "..\ctn\winctn\scripts"
	headerexport.bat
	cd "..\..\..\mesa"

	cd "external"
	headerexport.bat
	cd ".."


library:
	cd "winmesa\mesa_lib"
	nmake /f w32_install.mak install
	cd "..\.."
	cd "lib"
	nmake /f w32_install.mak install
	cd "..\.."

java:
	cd "javamesa"
	$(MAKE) /f w32_install.mak install
	cd ".."

	cd "javaexternal"
	$(MAKE) /f w32_install.mak install
	cd ".."

#	cd "winmesa\javactn"
#	$(MAKE) /f w32_install.mak install
#	cd "..\.."
#
#	cd "java_apps"
#	$(MAKE) /f w32_install.mak install
#	cd "..\.."

x_webmesa:
	cd "webmesa\mesa-iti"
	$(MAKE) /f w32_install.mak install
	cd "..\.."

x_apps:
	copy ..\xerces-c-3.1.1-x86-windows-vc-8.0\bin\xerces-c_3_1.dll $(MESA_TARGET)\bin
	cd "winmesa\mesa_apps"
	$(MAKE) /f w32_install.mak install
	cd "..\.."

x_dlls:
#	copy $(SYSTEMROOT)\system32\MSVCP71.dll $(MESA_TARGET)\bin
#	copy $(SYSTEMROOT)\system32\MSVCR71.dll  $(MESA_TARGET)\bin
#	copy $(SYSTEMROOT)\system32\MSVCP71D.dll $(MESA_TARGET)\bin
#	copy $(SYSTEMROOT)\system32\MSVCR71D.dll $(MESA_TARGET)\bin
#	copy $(MSFTVS8)\msvcm80.dll $(MESA_TARGET)\bin
#	copy $(MSFTVS8)\msvcp80.dll $(MESA_TARGET)\bin
#	copy $(MSFTVS8)\msvcr80.dll $(MESA_TARGET)\bin
# Visual Studio 2010
	copy "$(DLL_SOURCE)"\msvcp100.dll $(MESA_TARGET)\bin
	copy "$(DLL_SOURCE)"\msvcr100.dll $(MESA_TARGET)\bin
	
x_runtime:
	cd "runtime"
	$(MAKE) /f w32_install.mak install
	cd ".."

x_scripts:
	cd "scripts"
	$(MAKE) /f w32_install.mak install
	cd ".."

x_dbscripts:
	cd "dbscripts\sql_server_2005"
	$(MAKE) /f w32_install.mak install
	cd "..\.."

x_html:
	cd "html"
	$(MAKE) /f w32_install.mak install
	cd ".."

iti_html:
	cd html
	nmake/f w32_install.mak install
	cd ..

x_testdata:
	cd "mesa_tests\rad\msgs"
	perl create_messages.pl
	cd "..\.."
	xcopy/E/Y rad $(MESA_TARGET)\mesa_tests\rad
	cd ".."
	cd "mesa_tests\card\msgs"
	perl create_messages.pl
	cd "..\.."
	xcopy/E/Y card $(MESA_TARGET)\mesa_tests\card
	cd ".."

library_clean:
	cd "winmesa\mesa_lib"
	nmake /f w32_install.mak clean
	cd "..\.."

apps_clean:
	cd "winmesa\mesa_apps"
	$(MAKE) /f w32_install.mak clean
	cd "..\.."

java_clean:
	cd "..\ctn\javactn\DICOM"
	$(MAKE) /f w32_install.mak clean
	cd "..\..\..\.."

	cd "javamesa"
	$(MAKE) /f w32_install.mak clean
	cd ".."

	cd "winmesa\javactn"
	$(MAKE) /f w32_install.mak clean
	cd "..\.."

	cd "java_apps"
	$(MAKE) /f w32_install.mak clean
	cd ".."


x_secure_headers :
	cd "winmesa\scripts"
	secureheaderexport.bat
	cd "..\.."

x_secure_lib:
	cd "winmesa\mesa_lib_secure"
	nmake /f w32_install.mak install
	cd "..\.."

x_secure_apps:
	copy ..\openssl-0.9.8k\out32dll\ssleay32.dll $(MESA_TARGET)\bin
	copy ..\openssl-0.9.8k\out32dll\libeay32.dll $(MESA_TARGET)\bin
	cd "winmesa\mesa_apps_secure"
	nmake/f w32_install.mak install
	cd "..\.."

secure_library_clean:
	cd "winmesa\mesa_lib_secure"
	nmake /f w32_install.mak clean
	cd "..\.."

secure_apps_clean:
	cd "winmesa\mesa_apps_secure"
	$(MAKE) /f w32_install.mak clean
	cd "..\.."

# Debug entries below this line

install_debug :
#	$(MAKE) /f w32_install.mak directories
	$(MAKE) /f w32_install.mak headers
	$(MAKE) /f w32_install.mak library_debug
	$(MAKE) /f w32_install.mak java
	$(MAKE) /f w32_install.mak apps_debug
	$(MAKE) /f w32_install.mak x_runtime
	$(MAKE) /f w32_install.mak x_scripts
	$(MAKE) /f w32_install.mak x_dbscripts
	$(MAKE) /f w32_install.mak x_testdata

clean_debug:
	$(MAKE) /f w32_install.mak library_clean_debug
	$(MAKE) /f w32_install.mak java_clean
	$(MAKE) /f w32_install.mak apps_clean_debug


library_debug:
	cd "winmesa\mesa_lib"
	nmake /f w32_install.mak install_debug
	cd "..\.."

apps_debug:
#	copy ..\ACE_wrappers\bin\ace.dll $(MESA_TARGET)\bin
	cd "winmesa\mesa_apps"
	$(MAKE) /f w32_install.mak install_debug
	cd "..\.."

library_clean_debug:
	cd "winmesa\mesa_lib"
	nmake /f w32_install.mak clean_debug
	cd "..\.."


apps_clean_debug:
	cd "winmesa\mesa_apps"
	$(MAKE) /f w32_install.mak clean_debug
	cd "..\.."


