#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# MR/MR7

$x -q -r -a MR7 -c X localhost 2100 $IMAGE_SRC/toshiba/TMS04/*
if ($status != 0) then
  echo Failed to send MR/MR7
  exit 1
endif

cd $TARGET/modality/MR/MR7
mv 1.2.840.113701.4.1.6653.3.264.4.9 MR7S1
cd MR7S1
set base = MR7S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
