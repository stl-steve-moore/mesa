#!/bin/csh

set x = $MESA_TARGET/bin/cstore

# CT/CT3

$x -d CT3.delta -q -r -a CT3 -c X localhost 2100 $IMAGE_SRC/algotec/ALGO00000/*
if ($status != 0) then
  echo Failed to send CT/CT3
  exit 1
endif

echo Storage complete

cd $TARGET/modality/CT/CT3
mv 2.16.376.1.1.511752826.1.2.21459.3526228 CT3S1

echo Directory rename complete

cd CT3S1
set base = CT3S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

