#!/bin/csh

set x = $MESA_TARGET/bin/cstore

# CT/CT1

$x -d CT1.delta -q -r -a CT1 -c X localhost 2100 $IMAGE_SRC/ge/THU9948/*
if ($status != 0) then
  echo Failed to send CT/CT1
  exit 1
endif

cd $TARGET/modality/CT/CT1
mv 1.2.840.113674.514.212.81.300 CT1S1
mv 1.2.840.113674.514.212.82.300 CT1S2

cd CT1S1
set base = CT1S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end


cd ../CT1S2
set base = CT1S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
