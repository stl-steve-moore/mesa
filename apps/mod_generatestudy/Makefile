include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mod_generatestudy

app:	$(APPS)

#OBJS = mod_generatestudy.o weld.o MPPSAsst.o MLNSet.o MLNCreate.o 
#OBJS = mod_generatestudy.o weld.o MLNSet.o MLNCreate.o 
OBJS = mod_generatestudy.o 

mod_generatestudy:	$(OBJS)
	$(CXX) -o mod_generatestudy $(OBJS) $(L_FLAGS) $(LIBS_MESA)


relink:
	$(CXX) -o mod_generatestudy $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mod_generatestudy $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

data:
	dcm_create_object -i ncreate.tpl NCreateTemplate.dcm
	dcm_create_object -i nset.tpl NSetTemplate.dcm
	../../scripts/createdirectory mwl
	../mwlquery/mwlquery -o ./mwl -f ../mwlquery/q1.dcm localhost 2250 > /dev/null

test:
	./mod_generatestudy -M MR -m -p p.dcm localhost 2350

t1:
	./mod_generatestudy -m MR -p M3030 -s X1_A1 -c X1 \
 -i $(MESA_STORAGE)/modality/MR/MR4/MR4S1 \
 -t $(MESA_STORAGE)/modality/P1 \
 -y $(MESA_STORAGE)/modality/mwl \
 -z "IHE Protocol 1" 

t2:
	./mod_generatestudy -M MR -p M3020 \
 -x P1 -y mwl localhost 2350

t3:
	./mod_generatestudy -m MR -p M3040 -s X3A_A1 -s X3B_A1 -c X3 \
-i $(MESA_STORAGE)/modality/MR/MR4/MR4S1 \
-t x \
-y $(MESA_STORAGE)/modality/mwl \
-z "IHE Protocol 3"

t5:
	./mod_generatestudy -m MR -p T9020 -r "SUNDAY^J1" -c X2 \
-i $(MESA_STORAGE)/modality/MR/MR4/MR4S1 \
-t x \
-z "IHE Protocol 3"

t6:
	./mod_generatestudy -g -m MR -p MM222  -s X6_A1 -s X7_A1 -c X6-7 \
-i $(MESA_STORAGE)/modality/MR/MR4/MR4S1 \
-t /opt/mesa/storage/modality/T222 -y mwl/results -z "IHE Protocol 1"

t7:
	./mod_generatestudy -m IVUS -p 20101 -s XX-20012 -c YY-20012 -i /opt/mesa/storage/modality/MR/MR4/MR4S1 -t /opt/mesa/storage/modaltity/T20101_IVUS -y mwl/results -z "IHE Protocol 1"
