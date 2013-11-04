#!/bin/csh
#
# CreateDocReferenceTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach script (createdoc_reference.sql load_doc_reference.sql)
 echo $script
 psql $1 < $script
 if ($status != 0) then
  echo Failed in CreateDocReferenceTables.csh on script $script
  exit 1
 endif
end

