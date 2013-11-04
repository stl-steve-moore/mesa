#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CT/CT4

$x -q -r -a CT4 -c X localhost 2100 $IMAGE_SRC/algotec/ALGO00002/*
if ($status != 0) then
  echo Failed to send CT/CT4
  exit 1
endif

cd $TARGET/modality/CT/CT4
mv 2.16.376.1.1.511752826.1.2.3390586.6591071 CT4S1

cd CT4S1
set base = CT4S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

