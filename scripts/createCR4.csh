#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CR/CR4

$x -q -r -a CR4 -c X localhost 2100 $IMAGE_SRC/fuji/FUJI95707/*
if ($status != 0) then
  echo Failed to send CT/CT1
  exit 1
endif

cd $TARGET/modality/CR/CR4
mv 1.2.392.200036.9125.0.199402091242.1 CR4S1

cd CR4S1
set base = CR4S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

