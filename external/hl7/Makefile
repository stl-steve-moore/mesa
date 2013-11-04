include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
CC_FLAGS = $(C_OPTS)

OBJS = hl7_api.o

libimexa.a: $(OBJS)
	ar cvr libimexa.a $(OBJS)

install:	libimexa.a
	cp libimexa.a $(MESA_LIB)
	$(INSTALLINCLUDE) hl7_api.h $(MESA_INCLUDE)

clean:
	rm -rf Template.DB libimexa.a $(OBJS)
