include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_sr_eval

app:	$(APPS)

OBJS = mesa_sr_eval.o

mesa_sr_eval:	$(OBJS)
	$(CXX) -o mesa_sr_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_sr_eval $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_sr_eval $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:
	./mesa_sr_eval -t 2000:DCM rpt.dcm

t1v:
	./mesa_sr_eval -v -t 2000:DCM rpt.dcm

t2:
	./mesa_sr_eval -t 2000:DCMX rpt.dcm

t2v:
	./mesa_sr_eval -v -t 2000:DCMX rpt.dcm


t3:
	./mesa_sr_eval -t 2000:DCM -p rpt.dcm rpt.dcm

t3v:
	./mesa_sr_eval -v -t 2000:DCM -p rpt.dcm rpt.dcm

T4 = ../../testdata/y3_actor/actors/rpt_crt/601
T4SR = ../../testdata/y3_actor/msgs/sr/601
t4:
	./mesa_sr_eval -r $(T4)/sr_601_req.txt -t 2000:DCM -p $(T4SR)/sr_601cr.dcm $(T4SR)/sr_601cr.dcm 

t4v:
	./mesa_sr_eval -v -r $(T4)/sr_601_req.txt -t 2000:DCM -p $(T4SR)/sr_601cr.dcm $(T4SR)/sr_601cr.dcm 

t4w:
	./mesa_sr_eval -v $(T4SR)/sr_601cr.dcm 

T511SR = ../../testdata/y3_actor/msgs/sr/511

t511:	
	./mesa_sr_eval -r sr_511_req.txt -t 2010:DCM -p $(T511SR)/sr_511_cr.dcm $(T511SR)/sr_511_cr.dcm

t511w:	
	./mesa_sr_eval -v $(T511SR)/sr_511_cr.dcm

t511v:	
	./mesa_sr_eval -v -r sr_511_req.txt -t 2010:DCM -p $(T511SR)/sr_511_cr.dcm $(T511SR)/sr_511_cr.dcm

t511x:	
	./mesa_sr_eval -v -r sr_511_req.txt -t 2010:DCM -p $(T511SR)/sr_511_cr.dcm $(T4SR)/sr_601cr.dcm

t511z:	
	./mesa_sr_eval -v -r sr_511_req.txt -p $(T511SR)/sr_511_cr.dcm $(T4SR)/sr_601cr.dcm

t511a:	
	./mesa_sr_eval -v -r sr_511_req.txt -p sr_511_cr.dcm kon.dcm

t601:	sr_601cr_v.dcm
	./mesa_sr_eval -v -o PREDECESSOR -r sr_601_req.txt -p sr_601cr_v.dcm sr_601cr_v.dcm

t414:	sr_512_ct.dcm
	./mesa_sr_eval -v -r sr_414_req.txt -p sr_512_ct.dcm sr_512_ct.dcm

t601x:
	./mesa_sr_eval -p x/mesa.dcm -t 2000:DCMR x/test.dcm

data:	sr_601cr.dcm sr_601cr_x.dcm
sr_601cr.dcm:
	dcm_create_object -i sr_601cr.txt sr_601cr.dcm
sr_601cr_x.dcm:
	dcm_create_object -i sr_601cr_x.txt sr_601cr_x.dcm

sr_601cr_v.dcm:
	dcm_create_object -i ../../testdata/y3_actor/msgs/sr/601/sr_601cr_v.txt sr_601cr_v.dcm

sr_512_ct.dcm:
	dcm_create_object -i ../../testdata/y3_actor/msgs/sr/512/sr_512_ct.txt sr_512_ct.dcm
