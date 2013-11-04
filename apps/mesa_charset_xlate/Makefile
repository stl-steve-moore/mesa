include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_charset_xlate

app:	$(APPS)

OBJS = mesa_charset_xlate.o

mesa_charset_xlate:	$(OBJS)
	$(CXX) -o mesa_charset_xlate $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_charset_xlate $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

relink:
	$(CXX) -o mesa_charset_xlate $(OBJS) $(L_FLAGS) $(LIBS_MESA)


t1:	mesa_charset_xlate
	./mesa_charset_xlate -i HL7ISO2022JP -o DICOMISO2022JP hl7.txt dicom.txt

