#!/bin/csh
#
# CreateSVSTables.csh
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach script (createsvs.sql load_svs_data.sql )
 echo $script
 psql $1 < $script
 if ($status != 0) then
  echo Failed in CreateSVSTables.csh on script $script
  exit 1
 endif
end

