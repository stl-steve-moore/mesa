include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_image_pattern

app:	$(APPS)

OBJS = mesa_image_pattern.o

mesa_image_pattern:	$(OBJS)
	$(CXX) -g -o mesa_image_pattern $(OBJS) $(L_FLAGS) $(LIBS_MESA_NODB)

install:	$(APPS)
	$(INSTALL) mesa_image_pattern $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

p1:	mesa_image_pattern
	./mesa_image_pattern 1 p1.pixels

p29:	mesa_image_pattern
	./mesa_image_pattern 29 p29.pixels
