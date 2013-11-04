#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CR/CR3

$x -q -r -a CR3 -c X localhost 2100 $IMAGE_SRC/fuji/FUJI95714/*
if ($status != 0) then
  echo Failed to send CT/CT1
  exit 1
endif

cd $TARGET/modality/CR/CR3
mv 1.2.392.200036.9125.0.199302241758.16 CR3S1

cd CR3S1
set base = CR3S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

