all:
	cd ctn/facilities; make links
	cd ctn/libsrc;	make -f Makefile.mesa install
	cd ctn/apps;	make
	cd ctn/javactn;	make all
	cd hl7;		make

install:
	../../ctn/apps/scripts/createdirectory ../../ctn/include
	../../ctn/apps/scripts/createdirectory ../../ctn/lib
	../../ctn/apps/scripts/createdirectory $(CTN_LIB)
#	../../ctn/apps/scripts/createdirectory $(MESA_ROOT)/external/ctn/bin
	cp xerces-c-src1_7_0/lib/libxerces-c1_7_0.so $(MESA_TARGET)/lib
	cd ../../ctn/facilities; make links; make headerexport
	cd ../../ctn/libsrc;	make -f Makefile.mesa install
	cd ../../ctn/apps;	make install-lite
	cd ../../ctn/javactn;	make install
	cd hl7;		make install
	cd cgihtml-1.69;	make -f Makefile.mesa install

clean:
	cd ../../ctn/libsrc;	make -f Makefile.mesa clean
	cd ../../ctn/apps;	make clean
	cd ../../ctn/lib;	rm -f */*a
	cd ../../ctn/javactn;	make clean
	cd hl7;		make clean
