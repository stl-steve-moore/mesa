#!/bin/csh

set x = $MESA_TARGET/bin/send_image
set PICKER = $IMAGE_SRC/picker

# MR/MR9

$x -q -r -a MR9 -c X localhost 2100 \
  $PICKER/2.16.840.1.113662.4.8796818069641.798806497.93296077602350.10/*

if ($status != 0) then
  echo Failed to send MR/MR9
  exit 1
endif

cd $TARGET/modality/MR/MR9
mv 2.16.840.1.113662.4.8796818069641.806010667.284225018829304176 MR9S1
mv 2.16.840.1.113662.4.8796818069641.806011078.758642700465544040 MR9S2
cd MR9S1
set base = MR9S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

cd ../MR9S2
set base = MR9S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
