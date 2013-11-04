include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_xml_eval

app:	$(APPS)

OBJS = mesa_xml_eval.o DOMTreeErrorReporter.o

mesa_xml_eval:	$(OBJS)
	$(CXX) -o mesa_xml_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA_XERCESC)

relink:
	$(CXX) -o mesa_xml_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA_XERCESC)

install:	$(APPS)
	$(INSTALL) mesa_xml_eval $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

start-stop:	mesa_xml_eval
	./mesa_xml_eval start-stop.xml

pr1:	mesa_xml_eval
	./mesa_xml_eval pr1.xml

t1:	mesa_xml_eval
	./mesa_xml_eval t1.xml
