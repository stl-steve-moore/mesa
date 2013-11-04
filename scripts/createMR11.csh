#!/bin/csh

set x = $MESA_TARGET/bin/send_image
set PICKER = $IMAGE_SRC/picker

# MR/MR11

$x -q -r -a MR11 -c X localhost 2100 \
  $PICKER/2.16.840.1.113662.4.8796818069641.798806497.93296077602350.30/*

if ($status != 0) then
  echo Failed to send MR/MR11
  exit 1
endif

cd $TARGET/modality/MR/MR11
mv 2.16.840.1.113662.4.8796818069641.806076930.1397409083040939287 MR11S1
mv 2.16.840.1.113662.4.8796818069641.806077236.523684471630417572 MR11S2
mv 2.16.840.1.113662.4.8796818069641.806078039.102537520065321141 MR11S3
cd MR11S1
set base = MR11S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

cd ../MR11S2
set base = MR11S2IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

cd ../MR11S3
set base = MR11S3IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end
