#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# MR/MR5

$x -q -r -a MR5 -c X localhost 2100 $IMAGE_SRC/ge/1.2.840.113674.1335.106.200/*
if ($status != 0) then
  echo Failed to send MR/MR5
  exit 1
endif

cd $TARGET/modality/MR/MR5
mv 1.2.840.113674.1335.106.184.300 MR5S1
mv 1.2.840.113674.1335.106.185.300 MR5S2
cd MR5S1
set base = MR5S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
cd ../MR5S2
set base = MR5S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
