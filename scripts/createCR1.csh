#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CR/CR1

$x -q -r -a CR1 -c X localhost 2100 $IMAGE_SRC/fuji/FUJI95701/*
if ($status != 0) then
  echo Failed to send CT/CT1
  exit 1
endif

cd $TARGET/modality/CR/CR1
mv 1.2.392.200036.9125.0.198811291108.7 CR1S1

cd CR1S1
set base = CR1S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

