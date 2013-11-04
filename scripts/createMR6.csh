#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# MR/MR6

$x -q -r -a MR6 -c X localhost 2100 $IMAGE_SRC/toshiba/TMS05/*
if ($status != 0) then
  echo Failed to send MR/MR6
  exit 1
endif

cd $TARGET/modality/MR/MR6
mv 1.2.840.113701.4.1.1.3.3477.4.1 MR6S1
cd MR6S1
set base = MR6S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
