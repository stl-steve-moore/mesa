include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)

CLASS_FILES = MSRContentItem MSRContentItemCode MSRContentItemContainer \
 MSRContentItemFactory \
 MSRContentItemImage \
 MSRContentItemPName MSRContentItemText MSRWrapper

HEADERS = $(CLASS_FILES:=.hpp)
OBJS = $(CLASS_FILES:=.o)

libsr.a: $(OBJS)
	ar cvr libsr.a $(OBJS)

install:	libsr.a
	cp libsr.a $(MESA_LIB)
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)

MSRContentItem.o: MSRContentItem.cpp MSRContentItem.hpp
MSRContentItemCode.o: MSRContentItemCode.cpp MSRContentItemCode.hpp MSRContentItem.hpp
MSRContentItemContainer.o: MSRContentItemContainer.cpp MSRContentItemContainer.hpp MSRContentItem.hpp
MSRContentItemPName.o: MSRContentItemPName.cpp MSRContentItemPName.hpp MSRContentItem.hpp
MSRContentItemText.o: MSRContentItemText.cpp MSRContentItemText.hpp MSRContentItem.hpp
MSRContentItemFactory.o: MSRContentItemFactory.cpp MSRContentItemFactory.hpp \
 MSRContentItem.hpp MSRContentItemCode.hpp MSRContentItemContainer.hpp \
 MSRContentItemPName.hpp MSRContentItemText.hpp

MSRWrapper.o: MSRWrapper.cpp MSRWrapper.hpp

doc:
	$(MESA_CLASS2HTML) $(HEADERS)

doc-install: doc
	../../scripts/createdirectory $(MESA_CLASS_DOCS)/sr
	cp *.html $(MESA_CLASS_DOCS)/sr

clean:
	rm -rf Template.DB libcxxctn.a $(OBJS) *.html *.?pp~

headerexport:
	$(INSTALLINCLUDE) $(HEADERS) $(MESA_INCLUDE)
