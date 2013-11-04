#!/bin/csh
#
# CreateXRefMgrTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach script (createpatient.sql createvisit.sql createissuer.sql)
 echo $script
 psql $1 < $script
 if ($status != 0) then
  echo Failed in CreateXRefMgrTables.csh on script $script
  exit 1
 endif
end

