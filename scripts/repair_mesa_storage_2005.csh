#!/bin/csh

if (! -e delta_ct1s1.txt) then
  echo "Run this script from the scripts directory"
  exit 1
endif

dcm_modify_object -i delta_ct1s1.txt $MESA_STORAGE/modality/CT/CT1/CT1S1/CT1S1IM1.dcm /tmp/x.dcm
dcm_rm_element 0020 0020 /tmp/x.dcm /tmp/y.dcm
dcm_ctnto10 /tmp/y.dcm /tmp/z.dcm
