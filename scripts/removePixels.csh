#!/bin/csh

foreach image (??/*/*/*)
 echo $image
 dcm_rm_group $image /tmp/x.dcm 7fe0
 if ($status != 0) then
  echo Could not remove group 7fe0 from image $image
  exit 1
 endif

 cp /tmp/x.dcm $image
end

rm /tmp/x.dcm
