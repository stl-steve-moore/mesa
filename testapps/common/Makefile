include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = token 

app:	$(APPS)

token:	token.o
	$(CXX) -o token token.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf $(APPS) core *.o
