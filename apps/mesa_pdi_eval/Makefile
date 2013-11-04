include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_pdi_eval

app:	$(APPS)

OBJS = mesa_pdi_eval.o

mesa_pdi_eval:	$(OBJS)
	$(CXX) -o mesa_pdi_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_pdi_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_pdi_eval $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	mesa_pdi_eval
	./mesa_pdi_eval -l 3 disk1 1


t2:	mesa_pdi_eval
	./mesa_pdi_eval -l 3 disk1 2

t3:	mesa_pdi_eval
	./mesa_pdi_eval -l 3 disk1 3

t4:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 4

t5:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 5

t6:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 6

t7:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 7

t8:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 8

t9:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 9

t10:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 10

t10a:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 . 10

t10b:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 x 10

t11:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 11

t11a:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 . 11

t11b:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 x 11

t12:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 12

t12a:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 . 12

t12b:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 x 12

t13:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 disk1 13

t14:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 x 14

t14a:	mesa_pdi_eval
	./mesa_pdi_eval -r 4 -l 4 EE 14
