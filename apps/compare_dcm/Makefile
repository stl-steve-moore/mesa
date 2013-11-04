#	Makefile for compare_dcm

NAME = compare_dcm
OBJ = $(NAME).o
include $(MESA_MAKE)

CFLAGS = $(C_OPTS) -I$(DICOM_INCLUDE) -I$(MESA_ROOT)/include
LFLAGS = $(L_OPTS)
#LFLAGS = -L$(DICOM_LIB) -L$(MESA_LIB) $(LIBPATH_DATABASE)
LIBS = $(LIBS_MESA)

application:	$(NAME)

install: $(NAME)
	$(INSTALL) $(NAME) $(DICOM_BIN)

clean:
	rm -rf $(NAME) *.o *.BAK *.bak *% core *~ debug

$(NAME): $(OBJ)
	$(CXX) -o $(NAME) -g $(LFLAGS) $(OBJ) $(LIBS) $(DEBUG_LIBS)

$(NAME).o: $(NAME).cpp
	$(CXX) $(CFLAGS) -c $(NAME).cpp

t1:
	./compare_dcm -o -m sr.ini sr_601cr.dcm sr_601cr.dcm
