install:
	createdirectory.bat $(MESA_BIN)
	copy text_var_sub.pl $(MESA_BIN)
	copy tpl_to_txt.pl $(MESA_BIN)
	copy createdirectory.bat $(MESA_BIN)
	copy mesa_version.bat $(MESA_BIN)
	copy hl7_attach_PDF.pl $(MESA_BIN)

clean:
