#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CR/CR2

$x -q -r -a CR2 -c X localhost 2100 $IMAGE_SRC/fuji/FUJI95706/*
if ($status != 0) then
  echo Failed to send CT/CT1
  exit 1
endif

cd $TARGET/modality/CR/CR2
mv 1.2.392.200036.9125.0.199212251200.28 CR2S1

cd CR2S1
set base = CR2S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

