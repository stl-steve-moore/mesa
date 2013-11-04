#!/bin/csh

set x = $MESA_TARGET/bin/send_image
set PICKER = $IMAGE_SRC/picker

# MR/MR10

$x -q -r -a MR10 -c X localhost 2100 \
  $PICKER/2.16.840.1.113662.4.8796818069641.798806497.93296077602350.20/*

if ($status != 0) then
  echo Failed to send MR/MR10
  exit 1
endif

cd $TARGET/modality/MR/MR10
mv 2.16.840.1.113662.4.8796818069641.806071178.202281855408674074 MR10S1
mv 2.16.840.1.113662.4.8796818069641.806071642.1354338707677139005 MR10S2
mv 2.16.840.1.113662.4.8796818069641.806072124.1443702882300307478 MR10S3
cd MR10S1
set base = MR10S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

cd ../MR10S2
set base = MR10S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

cd ../MR10S3
set base = MR10S3IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
