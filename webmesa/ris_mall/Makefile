TARGET = $(MESA_TARGET)/webmesa/ris_mall

# get all filenames without CVS dirs and dir names 
EXCLUDE = Makefile doc bin config tmp doc/images doc/secure CVS %/CVS

# list dirs
DIRS = $(TARGET)/bin $(TARGET)/scripts $(TARGET)/doc $(TARGET)/config $(TARGET)/doc/images \
    $(TARGET)/doc/secure
TMPDIR = $(TARGET)/tmp

install:
	install -d $(DIRS)
	install -d -m 777 $(TMPDIR)
	-cp --target-directory=$(TARGET) $(filter-out $(EXCLUDE), \
            $(wildcard *) )
	-cp --target-directory=$(TARGET)/bin $(filter-out $(EXCLUDE), $(wildcard bin/*))
	-cp --target-directory=$(TARGET)/scripts $(filter-out $(EXCLUDE), $(wildcard scripts/*))
	-cp --target-directory=$(TARGET)/doc $(filter-out $(EXCLUDE), $(wildcard doc/*))
	-cp --target-directory=$(TARGET)/doc/images \
		$(filter-out $(EXCLUDE), $(wildcard doc/images/*))
	-cp --target-directory=$(TARGET)/doc/secure \
		$(filter-out $(EXCLUDE), $(wildcard doc/secure/*) doc/secure/.htaccess)
	-cp --target-directory=$(TARGET)/config $(filter-out $(EXCLUDE), $(wildcard config/*))

clean:
	rm -rf $(TARGET)/*

