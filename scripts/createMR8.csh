#!/bin/csh

set x = $MESA_TARGET/bin/cstore

# MR/MR8

$x -d MR8.delta -q -r -a MR8 -c X localhost 2100 $IMAGE_SRC/siemens/SMS000013/*
if ($status != 0) then
  echo Failed to send MR/MR8
  exit 1
endif

cd $TARGET/modality/MR/MR8
mv 1.3.12.2.1107.5.8.1.123456789.199507271758050706635 MR8S1
cd MR8S1
set base = MR8S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
