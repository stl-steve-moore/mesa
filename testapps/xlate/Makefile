include $(MESA_MAKE)

C_FLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = xlsps

app:	$(APPS)

xlsps:	xlsps.o
	$(CXX) -o xlsps xlsps.o $(L_FLAGS) $(LIBS_MESA)

clean:
	rm -rf $(APPS) core *.o

data:
	dcm_create_object -i sps.txt sps.dcm
