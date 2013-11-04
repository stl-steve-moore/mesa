#!/bin/csh

set x = $MESA_TARGET/bin/send_image

# CT/CT5

set PICKER = $IMAGE_SRC/picker

$x -q -r -a CT5 -c X localhost 2100 \
 $PICKER/2.16.840.1.113662.2.1.53544936282433.12345.336.16650/*
if ($status != 0) then
  echo Failed to send CT/CT5
  exit 1
endif

cd $TARGET/modality/CT/CT5
mv 2.16.840.1.113662.2.1.53544936282433.12345.336.1665.9990 CT5S1

cd CT5S1
set base = CT5S1IM
@ a = 1
foreach image (*)
  mv $image $base$a.dcm
  @ a += 1
end

