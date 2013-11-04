#!/bin/csh

set x = $MESA_TARGET/bin/cstore

# CT/CT2

$x -d CT2.delta -q -r -a CT2 -c X localhost 2100 $IMAGE_SRC/siemens/SMS000018/*
if ($status != 0) then
  echo Failed to send CT/CT2
  exit 1
endif

cd $TARGET/modality/CT/CT2
mv 1.3.12.2.1107.5.8.1.12345678.199508041416590860429 CT2S1

cd CT2S1
set base = CT2S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

