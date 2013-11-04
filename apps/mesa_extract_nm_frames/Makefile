include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = mesa_extract_nm_frames

app:	$(APPS)

OBJS = mesa_extract_nm_frames.o LNMFrame.o LNMFrameDynamic.o LNMFrameStatic.o LNMFrameGated.o LNMFrameTomo.o LNMFrameGatedTomo.o LNMFrameReconTomo.o LNMFrameReconGatedTomo.o LNMFrameWholeBody.o

mesa_extract_nm_frames:	$(OBJS)
	$(CXX) -o mesa_extract_nm_frames $(OBJS) $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o mesa_extract_nm_frames $(OBJS) $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) mesa_extract_nm_frames $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

t1:	mesa_extract_nm_frames
	./mesa_extract_nm_frames -p ENERGY=1 -p DETECTOR=2 -p PHASE=1 /tmp/2422.dcm frames.raw

t3:	mesa_extract_nm_frames
	./mesa_extract_nm_frames -p ENERGY=1 -p DETECTOR=2 -p PHASE=1 test3.dcm test3.raw
