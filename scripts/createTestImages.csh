#!/bin/csh

if ($TARGET == "") then
  echo Need to set the TARGET env variable
  echo Try /drnoa/smm/mesa_v/mesa_storage_5.5.0
  exit 1
endif

if ($IMAGE_SRC == "") then
  echo Need to set the IMAGE_SRC env variable
  echo Try /drnoa/smm/rsna_images
  exit 1
endif


pushd $TARGET/modality

set x = $MESA_TARGET/bin/send_image

##############################
# MR/MR1
$x -q -r -a MR1 -c X localhost 2100 $IMAGE_SRC/ge/1.2.840.113674.1115.261.200/*
if ($status != 0) then
  echo Failed to send MR/MR1
  exit 1
endif

cd $TARGET/modality/MR/MR1
mv 1.2.840.113674.1115.261.178.300 MR1S1
mv 1.2.840.113674.1115.261.182.300 MR1S2
cd MR1S1
set base = MR1S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
cd ../MR1S2
set base = MR1S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

##################################
#MR/MR2
$x -q -r -a MR2 -c X localhost 2100 $IMAGE_SRC/ge/1.2.840.113674.1118.54.200/*
if ($status != 0) then
  echo Failed to send MR/MR2
  exit 1
endif

cd $TARGET/modality/MR/MR2
mv 1.2.840.113674.1118.54.179.300 MR2S1
mv 1.2.840.113674.1118.54.180.300 MR2S2
cd MR2S1
set base = MR2S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
cd ../MR2S2
set base = MR2S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

##################################
#MR/MR3
$x -q -r -a MR3 -c X localhost 2100 $IMAGE_SRC/ge/1.2.840.113674.1140.196.200/*
if ($status != 0) then
  echo Failed to send MR/MR3
  exit 1
endif

cd $TARGET/modality/MR/MR3
mv 1.2.840.113674.1140.196.180.300 MR3S1
mv 1.2.840.113674.1140.196.181.300 MR3S2
cd MR3S1
set base = MR3S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
rm *2.dcm *4.dcm *6.dcm *8.dcm *0.dcm

cd ../MR3S2
set base = MR3S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

##################################
#MR/MR4
$x -q -r -a MR4 -c X localhost 2100 $IMAGE_SRC/ge/1.2.840.113674.1242.214.200/*
if ($status != 0) then
  echo Failed to send MR/MR3
  exit 1
endif

cd $TARGET/modality/MR/MR4
mv 1.2.840.113674.1242.214.184.300 MR4S1
cd MR4S1
set base = MR4S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

#kill %1

popd

foreach study (CR1 CR2 CR3 CR4 CT1 CT2 CT3 CT4 CT5 MR5 MR6 MR7 MR8 MR9 MR10 MR11)
  echo $study
  ./create$study.csh
  if ($status != 0) then
    echo Failed when creating study $study
    exit 1
  endif
end
